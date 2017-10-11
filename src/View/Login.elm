module View.Login exposing (..)

import Model exposing (Model, Mdl)
import Msg
import Html exposing (Html, button, div, text, input)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Material.Textfield as Textfield
import Material

type alias Mdl =
    Material.Model

view: Model -> Html Msg.Msg
view model =
    Textfield.render Msg.Mdl [1] model.mdl
      [ Textfield.label "Enter password"
      , Textfield.floatingLabel
      , Textfield.password
    ]
    []
    -- div [] [
    --     input [ type_ "text", placeholder "username", onInput Msg.NameChange ] []
    --     , input [ type_ "password", placeholder "password", onInput Msg.PasswordChange ] []
    --     , button [ onClick Msg.Submit ] [ text "Login"]
    --     ]


