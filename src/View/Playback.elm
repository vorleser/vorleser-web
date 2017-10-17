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

view: Model -> Html Msg.Msg
view model =
  Grid.grid [] [
    Grid.cell []
    [ (div
        [ style
          [ ("bottom", "0")
          , ("position", "fixed")
          , ("width", "100%")
          , ("background-color", "white")
          ]
        ]
      [
        playPauseButton model,
        Slider.view [ Slider.onChange Msg.SetProgress, Slider.value model.playback.progress ] 
      ])
    ]
  ]

playPauseButton: Model -> Html Msg.Msg
playPauseButton model =
  let icon =
    if model.playback.playing then
      "pause"
    else
      "play_arrow"
  in
  Button.render Msg.Mdl [] model.mdl
  [Button.icon, Options.onClick Msg.TogglePlayback]
  [ Icon.i icon ]
