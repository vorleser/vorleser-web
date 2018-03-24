module View.Drawer exposing (..)

import Model exposing (Model, Mdl)
import Msg
import Html exposing (Html, button, div, text, input)
import Html.Attributes exposing (style, class)
import Html.Events exposing (onClick, onInput, keyCode)
import Material.Button as Button
import Material.Options as Options
import Material.Layout as Layout
import Material.Options as Options
import Material.Options as Options exposing (Style)
import Material.Snackbar as Snackbar
import Json.Decode
import Material
import Api

view: Model -> List (Html Msg.Msg)
view model =
  [ Layout.title [] [ text "Vorleser" ]
    , Layout.navigation [] [
      Layout.link
        [ Layout.href "https://github.com/vorleser/vorleser-web/issues" ]
        [ text "Report an Issue" ]
    ]
    , Layout.navigation [] [
        Layout.link
          [ Layout.href "https://github.com/vorleser/vorleser-web" ]
          [ Html.span [] [ text "github" ] ]
      ]
  ]
