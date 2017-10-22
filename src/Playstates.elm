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
          -- , timestamp = Date.toString datez
          , timestamp = "2011-10-05T14:48:00.000Z"
          }
      in
        { model | playstates = Dict.insert id new_playstate model.playstates}
    Nothing ->
      model
