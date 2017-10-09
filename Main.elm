import Html exposing (Html, button, div, text, input)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http exposing (jsonBody)
import Json.Decode
import Auth

main =
    Html.program { init = init, view = view, update = update, subscriptions = subscriptions }

type alias Model =
    {
        login_view: LoginView
    }

init : (Model, Cmd Msg)
init =
    (Model (LoginView  "" "" ""), Cmd.none)

model : Model
model =
    {
        login_view = LoginView  "" "" ""
    }

type alias LoginView =
    { name : String
    , password : String
    , password_repeat : String
    }

type LoginViewMsg = Submit | PasswordChange String | NameChange String | PasswordRepeatChange String
type Msg = Login (LoginViewMsg) | LoggedIn

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Login loginMsg ->
            let (data, cmd) =
                (loginViewUpdate loginMsg model.login_view) 
            in
                ({ model | login_view = data }, cmd)
            -- case loginMsg of
            --     _ ->
            --         (model, Cmd.none)
                -- PasswordChange ->
                --     model
                -- NameChange ->
                --     model
                -- PasswordRepeatChange ->
                --     model


loginViewUpdate : LoginViewMsg -> LoginView -> (LoginView, Cmd Msg)
loginViewUpdate msg model =
    case msg of
        PasswordRepeatChange s ->
            ({ model | password_repeat = s }, Cmd.none)
        PasswordChange s ->
            ({ model | password = s }, Cmd.none)
        NameChange s ->
            ({ model | name = s }, Cmd.none)
        Submit ->
            (model, Cmd.none)


view : Model -> Html Msg
view model =
    Html.map Login (loginView model)

loginView: Model -> Html LoginViewMsg
loginView model =
    div [] [
        input [ type_ "text", placeholder "username", onInput NameChange ] []
        , input [ type_ "password", placeholder "password", onInput PasswordChange ] []
        , input [ type_ "password", placeholder "repeat password", onInput PasswordChange ] []
        , button [ onClick Submit ] [ text "Login"]
        ]

subscriptions: Model -> Sub Msg
subscriptions model =
    Sub.none

login : String -> String -> Cmd Msg
login user password =
    let loginData =
        { name = user, password = password}
    in
        let request =
            Http.post "localhost:5000" (Http.jsonBody (Auth.loginSchema loginData)) Json.Decode.string
        in
            Http.send LoggedIn request
