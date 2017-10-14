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
    (\book -> (listItem model book))
    model.books
    )


listItem: Model -> Model.Audiobook -> Html Msg.Msg
listItem model book =
  let subtitle =
    case book.artist of
      Just author ->
        author ++ " — (" ++ formatTime book.length ++ ")"
      _ ->
        "(" ++ formatTime book.length ++ ")"
  in
    -- let playButton id =
    --   Button.render Mdl [k] model.mdl
    --   [ Button.icon
    --   , Buttonm.accent |> when (Set.member k model.toggles)
    --     ]
    -- in
      Lists.li [ Lists.withSubtitle ] [ Lists.content []
      [ text book.title
      , Lists.subtitle [] [ text subtitle ]
      ] ]


formatTime: Float -> String
formatTime seconds =
  let (hours, minutes) =
    ((round seconds) // 3600, ((round seconds) % 3600) // 60)
  in
    (String.padLeft 2 '0' (toString hours)) ++ ":" ++ (String.padLeft 2 '0' (toString minutes))
