module View.BookInfo exposing (..)

import Html exposing (Html, button, div, text, input)
import Html.Attributes exposing (..)
import View.Playback
import View.BookList
import Model exposing (Model, Mdl)
import Msg
import View.ChapterList

view: Model -> Html Msg.Msg
view model =
  (div [class "bookinfo"]
    [ View.ChapterList.view model
    ]
  )
