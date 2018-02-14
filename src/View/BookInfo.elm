module View.BookInfo exposing (..)

import Html exposing (Html, button, div, text, input, img)
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
      , case (model.loginToken, model.playback.currentBook) of
          (Just secret, Just book_id) ->
            let
                book = Util.getBookById model book_id
            in
              img [
                src ((Util.baseUrl model.serverUrl) ++ "/coverart/" ++ book_id ++ "?auth=" ++ secret)
              ]
              []
          (_, _) ->
            img [ src "default.jpg" ] []
      , details model
      , View.ChapterList.view model
    ]
  )

details: Model -> Html Msg.Msg
details model =
    let maybeBook = Maybe.map (Util.getBookById model) model.playback.currentBook
    in
      case maybeBook of
        (Just (Just book)) ->
          div [class "info-detail"] [ text <| "Artist:  " ++ (Maybe.withDefault "Unkown" book.artist) ]
        _ ->
          div [class "info-detail"] [ ]

title: Model -> Html Msg.Msg
title model =
  Html.h3 [] [(text (case model.playback.currentBook of
    Just id ->
      Maybe.withDefault "No Book Selected" <| Maybe.map .title (Util.getBookById model id)
    _ ->
      ""))]
