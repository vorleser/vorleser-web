module View.Playback exposing (..)
import Material.Slider as Slider
import Msg
import Html.Attributes exposing (style, class)
import Html exposing (Html, div)
import Model exposing (Model)
import Material.Grid as Grid
import Material.Button as Button
import Material.Options as Options
import Material.Icon as Icon
import Html exposing (Html, button, div, text, input, span)
import Dict
import View.ChapterList
import Util

view: Model -> Html Msg.Msg
view model =
  let
    height = if model.playbackView.expanded then
      "calc(100% - 64px)"
    else
      "10%"
    style_list =
      [ ("height", height) ]
  in
    (div
      [ style style_list
        , Html.Attributes.classList [
          ("mdl-shadow--16dp", True),
          ("control-box", True)
        ]
      ]
    ([
      (div
        [ class "playback-control-list" ]
        [
          (div [class "buttons"] [
              skipBackwardButton model
            , playPauseButton model
            , skipFowardButton model
          ])
          , progressWithTitle model
          , Slider.view [
              Slider.onChange (\x -> Msg.Playback (Msg.SetVolume (x / 100)))
            , Slider.value (model.playback.volume * 100)
            , Slider.min 0
            , Slider.max 100
            , Options.cs "volume"
          ]
        ]
      )
    ])
    )

progressWithTitle: Model -> Html Msg.Msg
progressWithTitle model =
    (div [class "progress-bar-with-title"] [
      Slider.view [
          Slider.onChange (\x -> Msg.Playback (Msg.SetProgressManually (x / 1000)))
        , Slider.value (model.playback.progress * 1000)
        , Slider.min 0
        , Slider.max ((Maybe.withDefault 0 (currentBookLength model)) * 1000)
        , Options.css "align-self" "stretch"
        , Options.cs "progress"
      ]
      , (span [Html.Attributes.class "mdl-color-text--grey-700"] [text (currentBookTitle model)])
    ])

skipFowardButton: Model -> Html Msg.Msg
skipFowardButton model =
  Button.render Msg.Mdl [] model.mdl
  [ Button.minifab
    , Button.colored
    , Options.cs "skip-forward"
    , Options.onClick (Msg.Playback <| Msg.SetProgressManually (model.playback.progress + 30))
  ]
  [ Icon.i "forward_30" ]

skipBackwardButton: Model -> Html Msg.Msg
skipBackwardButton model =
  Button.render Msg.Mdl [] model.mdl
  [ Button.minifab
    , Button.colored
    , Options.cs "skip-backward"
    , Options.onClick (Msg.Playback <| Msg.SetProgressManually (model.playback.progress - 30))
  ]
  [ Icon.i "replay_30" ]

playPauseButton: Model -> Html Msg.Msg
playPauseButton model =
  let icon =
    if model.playback.playing then
      "pause"
    else
      "play_arrow"
  in
  Button.render Msg.Mdl [] model.mdl
  [ Button.fab, Button.colored, Options.onClick (Msg.Playback Msg.TogglePlayback)]
  [ Icon.i icon ]

currentBookTitle : Model -> String
currentBookTitle model =
  Maybe.withDefault
  "No book playing"
  (case model.playback.currentBook of
    Just id ->
      let
          maybe_book = Util.getBookById model id
      in
        case maybe_book of
          Just book -> Just <| book.title ++ " — " ++ Util.formatPlaybackPositionSeconds model.playback.progress book.length
          Nothing -> Nothing
    _ ->
      Nothing)

currentBookLength : Model -> Maybe Float
currentBookLength model =
  (case model.playback.currentBook of
    Just id ->
      Maybe.map .length (Dict.get id model.books)
    _ ->
      Nothing)
