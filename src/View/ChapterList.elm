module View.ChapterList exposing (..)

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
import Material.Table as Table
import Material
import Material.Snackbar as Snackbar
import Dict
import Config

type alias Mdl =
  Material.Model

view: Model -> Html Msg.Msg
view model =
  let
    current_chapters =
      Maybe.withDefault
      []
      (Maybe.map
        (\id -> Maybe.withDefault [] (Dict.get id model.chapters))
        model.playback.currentBook)
  in
    (div
      [ class "chapter-list-scroll-container" ]
      [ Table.table []
      [ Table.thead []
        [ Table.tr []
          [ Table.th [] [text "Time"]
          , Table.th [] [text "Title"]
          ]
        ]
      , Table.tbody []
        (List.map2
          (\chapter -> \k -> (listItem model chapter k))
          current_chapters
          (List.range 0 (List.length current_chapters))
        )
      ] ]
    )

listItem: Model -> Model.Chapter -> Int -> Html Msg.Msg
listItem model chapter index =
  Table.tr
    [ Options.onClick (Msg.Playback (Msg.SetProgressManually chapter.start_time)) ]
    [ Table.td [ Table.numeric ] [ text (toString chapter.start_time)]
    , Table.td [] [ text (Maybe.withDefault "" chapter.title) ]
    ]