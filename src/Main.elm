import View.Login
import View.BookList
import Html exposing (Html, button, div, text, input)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http exposing (jsonBody)
import Json.Decode
import Auth
import Msg exposing (..)
import Model exposing (..)
import Material

main =
  Html.program { init = init, view = view, update = update, subscriptions = subscriptions }

init : (Model, Cmd Msg)
init =
  (Model (LoginViewModel  "" "") Nothing LoginView Material.model, Cmd.none)

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
          ({ model | loginToken = Just secret.secret, currentView = BookListView }, Cmd.none)
        Err e ->
          (model, Cmd.none)
    Mdl m ->
      Material.update Mdl m model

loginViewUpdate : LoginViewMsg -> LoginViewModel -> (LoginViewModel, Cmd Msg)
loginViewUpdate msg model =
  case msg of
    PasswordChange s ->
      ({ model | password = s }, Cmd.none)
    NameChange s ->
      ({ model | name = s }, Cmd.none)
    Submit ->
      (model, login model.name model.password)

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

login : String -> String -> Cmd Msg
login user password =
  let loginData =
        { email = user, password = password}
  in
      let request =
            Http.post "http://localhost:8000/api/auth/login"
            (Http.jsonBody <| Auth.loginEncoder loginData)
            Auth.sessionSecretDecoder
      in
          Http.send LoggedIn request
