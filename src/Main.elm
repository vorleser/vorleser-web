import Dict
import Date exposing (..)
import Json.Decode
import Html exposing (Html, button, div, text, input)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http exposing (jsonBody)
import Time
import Task

import Material
import Material.Snackbar as Snackbar
import Material.Helpers exposing (map1st, map2nd)
import Material.Layout as Layout
import Material.Snackbar as Snackbar

import Api
import Auth
import Config
import Playstates
import Error
import Msg exposing (..)
import Model exposing (..)
import Audio
import Session

import View.Login
import View.BookList

main =
  Html.program { init = init, view = view, update = update, subscriptions = subscriptions }

init : (Model, Cmd Msg)
init =
  (
  { loginView = LoginViewModel "" "" Nothing
  , loginToken = Nothing
  , currentView = LoginView
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
      let (data, cmd) =
            (loginViewUpdate loginMsg model.loginView)
      in
          ({ model | loginView = data }, cmd)
    LoggedIn token ->
      case token of
        Ok secret ->
          (
            { model | loginToken = Just secret.secret, currentView = BookListView }
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
            }, Cmd.none
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

playbackUpdate : PlaybackMsg -> Model -> (Model, Cmd Msg)
playbackUpdate msg model =
  case msg of
    PlayBook id ->
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
            ({ model | playback = { modelPlayback | currentBook = Just id, hasPlayed = False, progress = progress }},
              Audio.command
                (Audio.toJs (Audio.SetFile
                  (Config.baseUrlData ++ "/" ++ id ++ "?auth=" ++ secret )
                  progress
                  model.playback.volume)
                )
            )
          _ ->
            -- todo: display error here, should not be reachable
            (model, Cmd.none)
    BookReadyAt position ->
      let state = model.playback
      in
        if state.hasPlayed then
          (model, Cmd.none)
        else
          ({ model | playback = { state | hasPlayed = True } }, Audio.command (Audio.toJs (Audio.Play)))
    SetPlaying state ->
      let modelPlayback =
        model.playback
      in
        let newModel =
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
        (
          { model | playback = { modelPlayback | volume = volume }}
        , Audio.command (Audio.toJs (Audio.SetVolume volume))
        )

loginViewUpdate : LoginViewMsg -> LoginViewModel -> (LoginViewModel, Cmd Msg)
loginViewUpdate msg model =
  case msg of
    PasswordChange s ->
      ({ model | password = s }, Cmd.none)
    NameChange s ->
      ({ model | name = s }, Cmd.none)
    Submit ->
      (model, Api.login model.name model.password)

view : Model -> Html Msg
view model =
  Layout.render Mdl model.mdl [ Layout.fixedHeader ]
    { header = [
      Layout.row []
      [ Layout.title [] [ text Config.name ]
      , Layout.spacer
      , Layout.navigation [] [
          Layout.link
            [ Layout.href "https://github.com/hatzel/vorleser-web" ]
            [ Html.span [] [ text "github" ] ]
        ]
      ]
    ]
    , drawer = [ Html.text "LOL" ]
    , tabs = ([], [])
    , main = [(case model.currentView of
      LoginView ->
        View.Login.view model
      BookListView ->
        View.BookList.view model)]
    }

subscriptions: Model -> Sub Msg
subscriptions model =
  Sub.batch
  [ Audio.progress (\p -> (Msg.Playback (UpdateProgress p)))
  , Audio.playing (\play -> (Msg.Playback (SetPlaying play)))
  , Audio.ready (\pos -> (Msg.Playback (BookReadyAt pos)))
  , Session.getSession (\key -> (Msg.LoggedIn (Ok { secret = key })))
  , Time.every (Time.second * Config.playstateUploadInterval) (\_ -> (Msg.Playback UpdateRemotePlaystates))
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
  let
    resource = "logging in"
  in
    case error of
      Http.BadPayload info _ ->
        Debug.log info
          (Error.errorSnackbar model "" ("Error " ++  resource ++ ", got an unexpected payload."))
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
