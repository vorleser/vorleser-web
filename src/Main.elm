import Dict
import Date exposing (..)
import Json.Decode
import Html exposing (Html, button, div, text, input)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http exposing (jsonBody)
import Task

import Material
import Material.Snackbar as Snackbar
import Material.Helpers exposing (map1st, map2nd)

import Api
import Auth
import Config
import Playstates
import Audio
import Error
import Msg exposing (..)
import Model exposing (..)

import View.Login
import View.BookList

main =
  Html.program { init = init, view = view, update = update, subscriptions = subscriptions }

init : (Model, Cmd Msg)
init =
  (
  { loginView = LoginViewModel "" ""
  , loginToken = Nothing
  , currentView = LoginView
  , mdl = Material.model
  , books = Dict.empty
  , snackbar = Snackbar.model
  , playstates = Dict.empty
  , chapters = Dict.empty
  , playback = 
    { currentBook = Nothing
    , playing = False
    , progress = 0
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
            , Api.getEverything { model | loginToken = Just secret.secret }
          )
        Err err ->
          Error.handleHttpError err "logging in" model
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

playbackUpdate : PlaybackMsg -> Model -> (Model, Cmd Msg)
playbackUpdate msg model =
  case msg of
    PlayBook id ->
      let modelPlayback =
        model.playback
      in
        case model.loginToken of
          Just secret ->
            ({ model | playback = { modelPlayback | currentBook = Just id }}, 
              Audio.command
                (Audio.toJs (Audio.SetFile (Config.baseUrlData ++ "/" ++ id ++ "?auth=" ++ secret )))
            )
          _ ->
            -- todo: display error here, should not be reachable
            (model, Cmd.none)
    StartPlayingBook ->
      (model, Audio.command (Audio.toJs Audio.Play))
    SetPlaying state ->
      let modelPlayback =
        model.playback
      in
        let newModel =
          { model | playback = { modelPlayback | playing = state }}
        in
          (newModel, Api.updatePlaystates model )
    SetProgress new_progress ->
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
        , Audio.command (Audio.toJs (Audio.SkipTo new_progress))
        )
    -- PlaybackReady ->
    --   (model, Cmd.none)
    UpdateLocalPlaystate date ->
      ((Playstates.updateLocalPlaystate model date), Cmd.none)
    TogglePlayback ->
      (model, Audio.command (Audio.toJs Audio.Toggle))

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
  case model.currentView of
    LoginView ->
      View.Login.view model
    BookListView ->
      View.BookList.view model

subscriptions: Model -> Sub Msg
subscriptions model =
  Sub.batch
  [ Audio.progress (\p -> (Msg.Playback (SetProgress p)))
  , Audio.playing (\play -> (Msg.Playback (SetPlaying play)))
  , Audio.ready (\url -> (Msg.Playback (StartPlayingBook)))
  ]

chapterDict : List Chapter -> Dict.Dict String Chapter
chapterDict chapters =
  Dict.fromList (List.map (\c -> (c.audiobook_id, c)) chapters)

playstateDict : List Playstate -> Dict.Dict String Playstate
playstateDict states =
  Dict.fromList (List.map (\s -> (s.audiobook_id, s)) states)

bookDict : List Audiobook -> Dict.Dict String Audiobook
bookDict books =
  Dict.fromList (List.map (\b -> (b.id, b)) books)


                -- , SetProgress 
                --     (Maybe.withDefault
                --       0
                --       (Maybe.map (\state -> state.position) (Dict.get id model.playstates))
                --     )
              -- ]
