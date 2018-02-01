module View.Main exposing (..)

import Model exposing (Model, Mdl)
import Material.List as Lists
import Msg
import Html exposing (Html, button, div, text, input)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Material.Textfield as Textfield
import Material.Button as Button
import Material.Options as Options
import Material.Grid as Grid
import Material.Options as Options
import Material.Icon as Icon
import Material
import Material.Snackbar as Snackbar
import View.Playback
import View.BookInfo
import View.BookList
import View.ChapterList
import Dict
import Config
import Util

type alias Mdl =
  Material.Model

view: Model -> Html Msg.Msg
view model =
  (div [class "mainview"]
    [   View.BookInfo.view model
      , View.BookList.view model
      , View.Playback.view model
      , Snackbar.view model.snackbar |> Html.map Msg.Snackbar
    ]
  )

