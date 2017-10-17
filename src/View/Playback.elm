module View.Playback exposing (..)
import Material.Slider as Slider
import Msg
import Html exposing (Html)
import Model exposing (Model)
import Material.Grid as Grid
import Material.Button as Button

view: Model -> Html Msg.Msg
view model =
  Grid.grid [] [
    Grid.cell []
    [
      playPauseButton model,
      Slider.view [ Slider.onChange Msg.SetProgress, Slider.value model.playback.progress ] 
    ]
  ]

playPauseButton: Model -> Html Msg.Msg
playPauseButton model =
  Button.render Msg.Mdl [] model.mdl [] [Html.text "lol"]
