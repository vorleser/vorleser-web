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
import Material.Options as Options
import Material.Snackbar as Snackbar
import Material

type alias Mdl =
  Material.Model

view: Model -> Html Msg.Msg
view model =
  Grid.grid [] [
    Grid.cell []
    [ (userField model)
    , (passwordField model)
    , (loginButton model)
    , Snackbar.view model.snackbar |> Html.map Msg.Snackbar
    ]
    ]

passwordField: Model -> Html Msg.Msg
passwordField model =
  Textfield.render Msg.Mdl [0] model.mdl
  [ Textfield.label "Enter password"
  , Textfield.floatingLabel
  , Textfield.password
  , Options.onInput (Msg.Login << Msg.PasswordChange)
  ]
  []

userField: Model -> Html Msg.Msg
userField model =
  Textfield.render Msg.Mdl [1] model.mdl
  [ Textfield.label "Enter username"
  , Textfield.floatingLabel
  , Textfield.text_
  , Options.onInput (Msg.Login << Msg.NameChange)
  ]
  []

loginButton: Model -> Html Msg.Msg
loginButton model =
  Button.render Msg.Mdl [1] model.mdl
  [ Button.raised
  , Button.ripple
  , Options.onClick (Msg.Login Msg.Submit)
  ]
  [ text "Login"]
