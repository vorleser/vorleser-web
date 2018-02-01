module View.BookInfo exposing (..)

import Html exposing (Html, button, div, text, input)
import Html.Attributes exposing (..)
import View.Playback
import View.BookList
import Model exposing (Model, Mdl)
import Msg
import View.ChapterList
import Util

view: Model -> Html Msg.Msg
view model =
  (div [class "bookinfo"]
    [ title model
      , View.ChapterList.view model
    ]
  )


title: Model -> Html Msg.Msg
title model =
  Html.h3 [] [(text (case model.playback.currentBook of
    Just id ->
      Maybe.withDefault "No Book Selected" <| Maybe.map .title (Util.getBookById model id)
    _ ->
      ""))]
