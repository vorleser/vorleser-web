module View.Login exposing (..)

import Model exposing (Model, Mdl)
import Msg
import Html exposing (Html, button, div, text, input)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick, onInput, keyCode)
import Material.Textfield as Textfield
import Material.Button as Button
import Material.Options as Options
import Material.Grid as Grid
import Material.Options as Options
import Material.Options as Options exposing (Style)
import Material.Snackbar as Snackbar
import Json.Decode
import Material

type alias Mdl =
  Material.Model

view: Model -> Html Msg.Msg
view model =
  (div
    [ style [("display", "flex"), ("justify-content", "center")] ]
    [(div
      [ style
        [ ("display", "flex")
        , ("align-items", "center")
        , ("justify-content", "space-between")
        , ("flex-wrap", "wrap")
        , ("max-width", "50%")
        ]
      ]
      [ (userField model)
        , (passwordField model)
        , (loginButton model)
        , (Snackbar.view model.snackbar |> Html.map Msg.Snackbar)
      ])
    ])

passwordField: Model -> Html Msg.Msg
passwordField model =
  Textfield.render Msg.Mdl [0] model.mdl
  [ Textfield.label "Enter password"
  , Textfield.floatingLabel
  , Textfield.password
  , Textfield.value model.loginView.password
  , Options.css "margin" "20px"
  , Options.onInput <| Msg.Login << Msg.PasswordChange
  , Options.on "keydown" (Json.Decode.andThen isEnter keyCode)
  ]
  []

userField: Model -> Html Msg.Msg
userField model =
  Textfield.render Msg.Mdl [1] model.mdl
  [ Textfield.label "Enter username"
  , Textfield.floatingLabel
  , Options.css "margin" "20px"
  , Textfield.value model.loginView.name
  , Textfield.text_
  , Textfield.autofocus
  , Options.onInput <| Msg.Login << Msg.NameChange
  ]
  []

loginButton: Model -> Html Msg.Msg
loginButton model =
  Button.render Msg.Mdl [2] model.mdl
  [ Button.raised
  , Button.ripple
  , Options.css "align-self" "flex-end"
  , Options.css "margin-left" "auto"
  , Button.type_ "submit"
  , Options.on "keydown" (Json.Decode.andThen isEnter keyCode)
  , Options.onClick (Msg.Login Msg.Submit)
  ]
  [ text "Login"]

isEnter : number -> Json.Decode.Decoder Msg.Msg
isEnter code =
  if code == 13 then
    Json.Decode.succeed (Msg.Login Msg.Submit)
  else
    Json.Decode.fail ""
