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
        login_view: LoginView,
        login_token: Maybe String
    }

init : (Model, Cmd Msg)
init =
    (Model (LoginView  "" "" "") Nothing, Cmd.none)


type alias LoginView =
    { name : String
    , password : String
    , password_repeat : String
    }

type LoginViewMsg = Submit | PasswordChange String | NameChange String | PasswordRepeatChange String
type Msg = Login (LoginViewMsg) | LoggedIn (Result Http.Error String)

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Login loginMsg ->
            let (data, cmd) =
                (loginViewUpdate loginMsg model.login_view)
            in
                ({ model | login_view = data }, cmd)
        LoggedIn token ->
            case token of
                Ok str ->
                    ({ model | login_token = Just str }, Cmd.none)
                Err e ->
                    (model, Cmd.none)
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
            (model, login model.name model.password)


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
        Http.send LoggedIn (Http.post "localhost:5000" (Http.jsonBody (Auth.loginSchema loginData)) Json.Decode.string)
