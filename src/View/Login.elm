module View.Login exposing (..)

import Model exposing (Model, Mdl)
import Msg
import Html exposing (Html, button, div, text, input)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Material.Textfield as Textfield
import Material.Button as Button
import Material.Options as Options
import Material.Grid as Grid
import Material

type alias Mdl =
    Material.Model

view: Model -> Html Msg.Msg
view model =
    div [] [
      Grid.grid [] [
      Textfield.render Msg.Mdl [1] model.mdl
        [ Textfield.label "Enter username"
        , Textfield.floatingLabel
        , Textfield.text_
      ]
      [],
      Textfield.render Msg.Mdl [2] model.mdl
        [ Textfield.label "Enter password"
        , Textfield.floatingLabel
        , Textfield.password
      ]
      [],
      Button.render Msg.Mdl [1] model.mdl
        [ Button.raised
        , Button.ripple
        , Options.onClick (Msg.Login Msg.Submit)
        ]
        [ text "Login"]
      ]
    ]
    -- div [] [
    --     input [ type_ "text", placeholder "username", onInput Msg.NameChange ] []
    --     , input [ type_ "password", placeholder "password", onInput Msg.PasswordChange ] []
    --     , button [ onClick Msg.Submit ] [ text "Login"]
    --     ]

-- passwordField: Model -> Html Msg.Msg
-- passwordField model =
--     Textfield.render Msg.Mdl [2] model.mdl
--       [ Textfield.label "Enter password"
--       , Textfield.floatingLabel
--       , Textfield.password
--     ]
