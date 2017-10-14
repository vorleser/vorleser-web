import View.Login
import View.BookList
import Html exposing (Html, button, div, text, input)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http exposing (jsonBody)
import Config
import Json.Decode
import Auth
import Msg exposing (..)
import Model exposing (..)
import Material
import Api
import Task
import Material.Snackbar as Snackbar
import Material.Helpers exposing (map1st, map2nd)

main =
  Html.program { init = init, view = view, update = update, subscriptions = subscriptions }

init : (Model, Cmd Msg)
init =
  ({ loginView = LoginViewModel "" ""
  , loginToken = Nothing
  , currentView = LoginView
  , mdl = Material.model
  , data = ""
  , snackbar = Snackbar.model
  }, Cmd.none)

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Login loginMsg ->
      let (data, cmd) =
            (loginViewUpdate loginMsg model.loginView)
      in
          ({ model | loginView = data }, cmd)
    LoggedIn token ->
      case token of
        Ok secret ->
          ({ model | loginToken = Just secret.secret, currentView = BookListView }, Api.get_everything model)
        Err e ->
          (errorSnackbar model "" "Error logging in, check your network connection.")
    Mdl m ->
      Material.update Mdl m model
    RequestBooks ->
      (model, Api.get_everything model)
    Books input_result ->
      case input_result of
        Ok input_data ->
          ({ model | data = input_data }, Cmd.none)
        Err _ ->
          (errorSnackbar model "" "Error fetching books, check your network connection.")
    Snackbar msg_ ->
      Snackbar.update msg_ model.snackbar
          |> map1st (\s -> { model | snackbar = s })
          |> map2nd (Cmd.map Snackbar)
    -- Snackbar _ ->
    --   (model, Cmd.none)

errorSnackbar : Model -> String -> String -> (Model, Cmd Msg)
errorSnackbar model text name =
  (Tuple.mapSecond (Cmd.map Snackbar)
  (Tuple.mapFirst (\first -> { model | snackbar = first })
    (Snackbar.add (Snackbar.toast text name) model.snackbar)
  ))


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
  Sub.none
