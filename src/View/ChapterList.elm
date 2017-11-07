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
import Material
import Material.Snackbar as Snackbar
import View.Playback
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
    (div []
      [ (Lists.ul [
              Options.css "width" "90%"
            , Options.css "margin-bottom" "10%"
          ]
          (List.map2
            (\chapter -> \k -> (listItem model chapter k))
            current_chapters
            (List.range 0 (List.length current_chapters))
          )
        )
      ]
    )

listItem: Model -> Model.Chapter -> Int -> Html Msg.Msg
listItem model chapter index =
  Lists.li []
  [ Lists.content
    [ Options.onClick (Msg.Playback (Msg.SetProgressManually chapter.start_time)) ]
    [ text (Maybe.withDefault "" chapter.title)
    ]
  ]
