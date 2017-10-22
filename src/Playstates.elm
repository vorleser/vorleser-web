module Playstates exposing (..)
import Model exposing (Model)
import Maybe
import Date
import Dict

updateLocalPlaystate: Model -> Date.Date -> Model
updateLocalPlaystate model date =
  case model.playback.currentBook of
    Just id ->
      let
        new_playstate =
          { audiobook_id = id
          , position = model.playback.progress
          , timestamp = date
          }
      in
        { model | playstates = Dict.insert id new_playstate model.playstates}
    Nothing ->
      model
