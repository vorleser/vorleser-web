module View.Playback exposing (..)
import Material.Slider as Slider
import Msg
import Html.Attributes exposing (style)
import Html exposing (Html, div)
import Model exposing (Model)
import Material.Grid as Grid
import Material.Button as Button

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
  Button.render Msg.Mdl [] model.mdl [] [Html.text "Play/Pause"]
