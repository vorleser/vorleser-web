module View.Playback exposing (..)
import Material.Slider as Slider
import Msg
import Html.Attributes exposing (style)
import Html exposing (Html, div)
import Model exposing (Model)
import Material.Grid as Grid
import Material.Button as Button
import Material.Options as Options
import Material.Icon as Icon
import Html exposing (Html, button, div, text, input)
import Dict

view: Model -> Html Msg.Msg
view model =
  (div
    [ style
      [ ("bottom", "0")
      , ("position", "fixed")
      , ("width", "100%")
      , ("background-color", "white")
      , ("height", "10%")
      , ("display", "flex")
      , ("align-items", "center")
      , ("justify-content", "space-evenly")
      ]
      , Html.Attributes.classList [
        ("mdl-shadow--16dp", True)
      ]
    ]
  [
    (div
      [ style [
          ("display", "flex")
        , ("flex-grow", "1")
        , ("justify-content", "space-evenly")
        , ("align-items", "center")
        ]
      ]
      [
        playPauseButton model,
        Slider.view [
            Slider.onChange (\x -> Msg.Playback (Msg.SetProgressManually (x / 1000)))
          , Slider.value (model.playback.progress * 1000)
          , Slider.min 0
          , Slider.max ((Maybe.withDefault 0 (currentBookLength model)) * 1000)
          , Options.css "flex-grow" "0.8"
        ],
        text (currentBookTitle model)
      ]
    )
  ])

playPauseButton: Model -> Html Msg.Msg
playPauseButton model =
  let icon =
    if model.playback.playing then
      "pause"
    else
      "play_arrow"
  in
  Button.render Msg.Mdl [] model.mdl
  [ Button.icon, Options.onClick (Msg.Playback Msg.TogglePlayback)]
  [ Icon.i icon ]


currentBookTitle : Model -> String
currentBookTitle model =
  Maybe.withDefault
  "No book playing"
  (case model.playback.currentBook of
    Just id ->
      Maybe.map .title (Dict.get id model.books)
    _ ->
      Nothing)

currentBookLength : Model -> Maybe Float
currentBookLength model =
  (case model.playback.currentBook of
    Just id ->
      Maybe.map .length (Dict.get id model.books)
    _ ->
      Nothing)
