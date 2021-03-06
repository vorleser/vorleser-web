import Dict
import Date exposing (..)
import Json.Decode
import Html exposing (Html, button, div, text, input)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http exposing (jsonBody)
import Time
import Task
import Keyboard exposing (..)

import Material
import Material.Snackbar as Snackbar
import Material.Menu as Menu
import Material.Helpers exposing (map1st, map2nd)
import Material.Layout as Layout
import Material.Snackbar as Snackbar

import Api
import Auth
import Config
import Playstates
import PlaybackBehaviour
import Error
import Msg exposing (..)
import Model exposing (..)
import Audio
import Session
import Util

import View.ChapterList
import View.Login
import View.BookList
import View.Main
import View.Drawer

main =
  Html.programWithFlags { init = init, view = view, update = update, subscriptions = subscriptions }

type alias Flags = 
  { serverUrl: String
  , hideUrlField: Bool
  }

init : Flags -> (Model, Cmd Msg)
init flags =
  (
  { loginView = LoginViewModel flags.serverUrl flags.hideUrlField "" "" Nothing
  , loginToken = Nothing
  , currentView = LoginView
  , serverUrl = flags.serverUrl
  , mdl = Material.model
  , books = Dict.empty
  , snackbar = Snackbar.model
  , playstates = Dict.empty
  , chapters = Dict.empty
  , playbackView = { expanded = False }
  , playback =
    { currentBook = Nothing
    , playing = False
    , progress = 0
    , hasPlayed = False
    , volume = 1
    , playbackBehaviour = PlaybackBehaviour.Auto
    }
  }, Cmd.none)

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Mdl m ->
      Material.update Mdl m model
    Snackbar msg_ ->
      Snackbar.update msg_ model.snackbar
          |> map1st (\s -> { model | snackbar = s })
          |> map2nd (Cmd.map Snackbar)
    Login loginMsg ->
      (loginViewUpdate loginMsg model)
    Logout ->
      (model, Api.logout model)
    LoggedOut result ->
      case result of
        Ok _ ->
          (Tuple.first (init { serverUrl = model.loginView.serverUrl, hideUrlField = model.loginView.hideUrlField }),
            Cmd.batch
              [ Session.clearSession ()
              , Audio.command (Audio.toJs Audio.Stop)
              ]
          )
        Err err ->
          handleLogoutError err model
    LoggedIn token ->
      case token of
        Ok secret ->
          (
            { model | loginToken = Just secret.secret, currentView = MainView }
            , Cmd.batch [
                Api.getEverything { model | loginToken = Just secret.secret }
              , Session.saveSession secret.secret
            ]
          )
        Err err ->
          handleLoginError err model
    RequestEverything ->
      (model, Api.getEverything model)
    RequestBooks ->
      (model, Api.getBooks model)
    ReceiveAllData input_result ->
      case input_result of
        Ok data ->
          (
            { model |
              books = (bookDict data.books)
            , playstates = (playstateDict data.playstates)
            , chapters = (chapterDict data.chapters)
            }, Session.requestLastPlayed ()
          )
        Err err ->
          Error.handleHttpError err "fetching data" model
    ReceiveBooks input_result ->
      case input_result of
        Ok book_data ->
          ({ model | books = (bookDict book_data) }, Cmd.none)
        Err err ->
          Error.handleHttpError err "fetching books" model
    UpdatedPlaystates content ->
      Debug.log (toString content) (model, Cmd.none)
    Playback subMsg ->
      playbackUpdate subMsg model
    PlaybackViewExpand ->
      ({ model | playbackView = { expanded = True} }, Cmd.none)
    PlaybackViewCollapse ->
      ({ model | playbackView = { expanded = False} }, Cmd.none)
    UpdateServerUrl s ->
      updateServerUrl model s
    Startup info ->
      ({ model | serverUrl = info.serverUrl, loginToken = Just info.loginToken, currentView = MainView},
        Api.getEverything { model | serverUrl = info.serverUrl, loginToken = Just info.loginToken })
    Key code ->
      case model.currentView of
        MainView ->
          case code of
            _ -> (model, Task.succeed (Msg.Playback TogglePlayback ) |> Task.perform identity)
        _ ->
          (model, Cmd.none)
    LastPlayedInfo id ->
      case model.playback.currentBook of
        Nothing ->
          (playbackUpdate (PlayBook id PlaybackBehaviour.Manual) model)
          -- let playback = model.playback
          -- in ({model | playback = { playback | currentBook = Just id}}, Cmd.none)
        Just _ -> (model, Cmd.none)

playbackUpdate : PlaybackMsg -> Model -> (Model, Cmd Msg)
playbackUpdate msg model =
  case msg of
    PlayBook id autoplay ->
      let
        modelPlayback = model.playback
        progress =
          (Maybe.withDefault
              0
              (Maybe.map (\state -> state.position) (Dict.get id model.playstates))
          )
      in
        case model.loginToken of
          Just secret ->
            ({ model | playback = { modelPlayback | currentBook = Just id, hasPlayed = False, progress = progress, playbackBehaviour = autoplay }},
              Cmd.batch [
              Audio.command
                (Audio.toJs (Audio.SetFile
                  ((Util.dataUrl model.serverUrl) ++ "/" ++ id ++ "?auth=" ++ secret )
                  progress
                  model.playback.volume)
                ),
              Session.saveLastPlayed id
              ]
            )
          _ ->
            Debug.crash ("Logged in yet no login token. This is a bug, please report it.")
    BookReadyAt position ->
      let state = model.playback
      in
        if state.hasPlayed then
          (model, Cmd.none)
        else if state.playbackBehaviour == PlaybackBehaviour.Auto then
          ({ model | playback = { state | hasPlayed = True } }, Audio.command (Audio.toJs (Audio.Play)))
        else
          (model, Cmd.none)
    SetPlaying state ->
      let
        modelPlayback =
          model.playback
        newModel =
          { model | playback = { modelPlayback | playing = state }}
      in
        (newModel, Api.updatePlaystates model )
    UpdateProgress new_progress ->
      let modelPlayback =
        model.playback
      in
        ( { model | playback = { modelPlayback | progress = new_progress } }
        , Task.perform (\date -> Msg.Playback (UpdateLocalPlaystate date)) Date.now
        )
    SetProgressManually new_progress ->
      let modelPlayback =
        model.playback
      in
        ({ model | playback = { modelPlayback | progress = new_progress }}
        , Cmd.batch [
              Audio.command (Audio.toJs (Audio.SkipTo new_progress))
            , Api.updatePlaystates model
          ]
        )
    UpdateLocalPlaystate date ->
      ((Playstates.updateLocalPlaystate model date), Cmd.none)
    UpdateRemotePlaystates ->
      (model, Api.updatePlaystates model)
    TogglePlayback ->
      (model, Audio.command (Audio.toJs Audio.Toggle))
    SetVolume volume ->
      let modelPlayback =
        model.playback
      in
        ( { model | playback = { modelPlayback | volume = volume }}
        , Audio.command (Audio.toJs (Audio.SetVolume volume))
        )
    UpdateVolume volume ->
      let modelPlayback =
        model.playback
      in
        ({ model | playback = { modelPlayback | volume = volume }}, Cmd.none)

loginViewUpdate : LoginViewMsg -> Model -> (Model, Cmd Msg)
loginViewUpdate msg model =
  let login_model =
      model.loginView
  in
    case msg of
      ServerUrlChange s ->
        ({ model | loginView = { login_model | serverUrl = s }}, Cmd.none)
      PasswordChange s ->
        ({ model | loginView = { login_model | password = s }}, Cmd.none)
      NameChange s ->
        ({ model | loginView = { login_model | name = s }}, Cmd.none)
      Submit ->
        let (new_model, msg) =
          updateServerUrl model login_model.serverUrl
        in
          ( new_model
          , Cmd.batch [
              Api.login login_model.name login_model.password login_model.serverUrl
            , msg
          ]
          )

updateServerUrl : Model -> String -> (Model, Cmd Msg)
updateServerUrl model serverUrl =
  ({ model | serverUrl = serverUrl }, Session.saveServerUrl serverUrl)

view : Model -> Html Msg
view model =
  Layout.render Mdl model.mdl [ Layout.fixedHeader ]
    { header = [
      Layout.row []
      [ Layout.title [] [ text Config.name ]
      , Layout.spacer
      , Menu.render Mdl [100] model.mdl
        [ Menu.bottomRight ]
        (case model.loginToken of
          Just _ ->
            [ Menu.item
              [ Menu.onSelect Msg.Logout ]
              [ text "Logout" ]
            ]
          Nothing ->
            [])
      ]
    ]
    , drawer = View.Drawer.view model
    , tabs = ([], [])
    , main = [(case model.currentView of
        LoginView -> View.Login.view model
        MainView ->
            View.Main.view model
        BookListView ->
            View.BookList.view model
      )]
    }

subscriptions: Model -> Sub Msg
subscriptions model =
  Sub.batch
  [ Audio.progress (\p -> (Msg.Playback (UpdateProgress p)))
  , Audio.volume (\v -> (Msg.Playback (UpdateVolume v)))
  , Audio.playing (\play -> (Msg.Playback (SetPlaying play)))
  , Audio.ready (\pos -> (Msg.Playback (BookReadyAt pos)))
  , Session.startupInfo (\info -> (Msg.Startup info))
  , Session.getSession (\key -> (Msg.LoggedIn (Ok { secret = key })))
  , Session.getServerUrl (\url -> (Msg.UpdateServerUrl url))
  , Session.getLastPlayed (\id -> (Msg.LastPlayedInfo id))
  , Time.every (Time.second * Config.playstateUploadInterval) (\_ -> (Msg.Playback UpdateRemotePlaystates))
  , Keyboard.presses (\code -> Msg.Key code)
  ]

chapterDict : List Chapter -> Dict.Dict String (List Chapter)
chapterDict chapters =
  List.foldr
    (\chapter dict -> Dict.update chapter.audiobook_id (appendIfJust chapter) dict)
    Dict.empty
    chapters

appendIfJust : v -> Maybe (List v) -> Maybe (List v)
appendIfJust chapter list =
  case list of
    Just l ->
      Just <| [chapter] ++ l
    Nothing ->
      Just [chapter]

playstateDict : List Playstate -> Dict.Dict String Playstate
playstateDict states =
  Dict.fromList (List.map (\s -> (s.audiobook_id, s)) states)

bookDict : List Audiobook -> Dict.Dict String Audiobook
bookDict books =
  Dict.fromList (List.map (\b -> (b.id, b)) books)

handleLoginError :  Http.Error -> Model.Model -> (Model.Model, Cmd Msg.Msg)
handleLoginError error model =
  handleNetworkError "logging in" error model

handleLogoutError :  Http.Error -> Model.Model -> (Model.Model, Cmd Msg.Msg)
handleLogoutError error model =
  handleNetworkError "logging out" error model

handleNetworkError :  String -> Http.Error -> Model.Model -> (Model.Model, Cmd Msg.Msg)
handleNetworkError resource error model =
  case error of
    Http.BadPayload info _ ->
      Error.errorSnackbar model "" ("Error " ++  resource ++ ", got an unexpected payload.")
    Http.NetworkError ->
      (Error.errorSnackbar model "" ("Error " ++ resource ++ ", check your network connection."))
    Http.BadStatus resp ->
      let
        login = model.loginView
      in
        case resp.status.code of
          401 ->
            ({ model | loginView = { login | error = Just "Invalid username or password!" } }, Cmd.none)
          _ ->
            (Error.errorSnackbar model "" ("Error " ++ resource ++ ". Bad status code: " ++ resp.status.message))
    Http.Timeout ->
      (Error.errorSnackbar model "" ("Timeout " ++ resource))
    Http.BadUrl _ ->
      (Error.errorSnackbar model "" "Bad url, how does this even happen?")
