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
import Material

type alias Mdl =
  Material.Model

view: Model -> Html Msg.Msg
view model =
  Lists.ul []
    (
    List.map
    (\book ->  Lists.li [] [ Lists.content [] [text book.title] ])
    model.books
    )
