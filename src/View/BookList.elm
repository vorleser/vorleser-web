module View.BookList exposing (..)

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
import View.ChapterList
import Dict
import Config
import Util

type alias Mdl =
  Material.Model

view: Model -> Html Msg.Msg
view model =
  (div [class "booklist"]
    [ (Lists.ul []
        (
        List.map2
        (\book -> \k -> (listItem model book k))
        (Dict.values model.books)
        (List.range 0 (Dict.size model.books))
      ))
    ]
  )

type ButtonSymbol = Pause | Play

listItem: Model -> Model.Audiobook -> Int -> Html Msg.Msg
listItem model book index =
  let
    subtitle =
      case book.artist of
        Just author ->
          author ++ " — (" ++ Util.formatTime book.length ++ ")"
        _ ->
          "(" ++ Util.formatTime book.length ++ ")"
    imageUrl =
      case model.loginToken of
        Just secret ->
          (Util.baseUrl model.serverUrl) ++ "/coverart/" ++ book.id ++ "?auth=" ++ secret
        _ ->
          Debug.crash "This is a bug!" -- this should be unreachable, TODO: error message or something similar
    button_symbol =
      case model.playback.currentBook of
        Just id ->
          if id == book.id && model.playback.playing then
            Pause
          else
            Play
        Nothing ->
            Play

  in
    Lists.li [ Lists.withSubtitle ]
    [ Lists.content []
      [ Lists.avatarImage imageUrl []
      , text book.title
      , playButton model index book.id button_symbol
      , Lists.subtitle [] [ text subtitle ]
      ]
    ]

playButton: Model -> Int -> String -> ButtonSymbol -> Html Msg.Msg
playButton model index id button_symbol =
  Button.render
  Msg.Mdl
  [index]
  model.mdl
  [ Button.icon
  , Options.onClick
    (case button_symbol of
      Play -> (Msg.Playback (Msg.PlayBook id))
      Pause -> (Msg.Playback (Msg.TogglePlayback))
    )
  , Options.css "float" "right"
  ]
  [ Icon.i
    (case button_symbol of
      Play -> "play_circle_outline"
      Pause -> "pause_circle_outline")
  ]
