module View.Login exposing (..)

import Model exposing (Model, Mdl)
import Msg
import Html exposing (Html, button, div, text, input)
import Html.Attributes exposing (style, class)
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
    []
    [(div
      [ class "login-form-container" ]
      (List.append
        (if model.loginView.hideUrlField then
          []
        else
          [(serverField model)]
        )
        [ (userField model)
        , (passwordField model)
        , (loginButton model)
        , (Snackbar.view model.snackbar |> Html.map Msg.Snackbar)
        ]))
    ])

passwordField: Model -> Html Msg.Msg
passwordField model =
  let params =
    [ Textfield.label "Enter password"
    , Textfield.floatingLabel
    , Textfield.password
    , Textfield.value model.loginView.password
    , Options.cs "login-field"
    , Options.onInput <| Msg.Login << Msg.PasswordChange
    , Options.on "keydown" (Json.Decode.andThen isEnter keyCode)
    ]
  in
    case model.loginView.error of
    Nothing ->
      Textfield.render Msg.Mdl [0] model.mdl
      params
      []
    Just error ->
      Textfield.render Msg.Mdl [0] model.mdl
      (params ++ [(Textfield.error error)])
      []

serverField: Model -> Html Msg.Msg
serverField model =
  let params =
    [ Textfield.label "Enter Server URL"
    , Textfield.floatingLabel
    , Options.cs "login-field"
    , Options.cs "server-field"
    , Textfield.value model.loginView.serverUrl
    , Textfield.text_
    , Textfield.autofocus
    , Options.onInput <| Msg.Login << Msg.ServerUrlChange
    ]
  in
    case model.loginView.error of
    Nothing ->
      Textfield.render Msg.Mdl [1] model.mdl
      params
      []
    Just error ->
      Textfield.render Msg.Mdl [1] model.mdl
      (params ++ [(Textfield.error error)])
      []

userField: Model -> Html Msg.Msg
userField model =
  let params =
    [ Textfield.label "Enter username"
    , Textfield.floatingLabel
    , Options.cs "login-field"
    , Textfield.value model.loginView.name
    , Textfield.text_
    , Options.onInput <| Msg.Login << Msg.NameChange
    ]
  in
    case model.loginView.error of
    Nothing ->
      Textfield.render Msg.Mdl [2] model.mdl
      params
      []
    Just error ->
      Textfield.render Msg.Mdl [2] model.mdl
      (params ++ [(Textfield.error error)])
      []

loginButton: Model -> Html Msg.Msg
loginButton model =
  Button.render Msg.Mdl [2] model.mdl
  [ Button.raised
  , Button.ripple
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
