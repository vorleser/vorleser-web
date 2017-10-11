module View.Login exposing (..)

import Model exposing (..)
import Msg
import Html exposing (Html, button, div, text, input)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)

view: Model -> Html Msg.LoginViewMsg
view model =
    div [] [
        input [ type_ "text", placeholder "username", onInput Msg.NameChange ] []
        , input [ type_ "password", placeholder "password", onInput Msg.PasswordChange ] []
        , button [ onClick Msg.Submit ] [ text "Login"]
        ]


