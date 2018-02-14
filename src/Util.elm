module Util exposing (..)
import Model
import Dict

baseUrl : String -> String
baseUrl url =
  if String.endsWith url "/" then
    url ++ "api"
  else
    url ++ "/api"

dataUrl : String -> String
dataUrl url =
  if String.endsWith url "/" then
    url ++ "data"
  else
    url ++ "/data"

formatTimeSeconds: Float -> String
formatTimeSeconds total_seconds =
  let
    seconds = (round total_seconds) % 60
  in
    (formatTime total_seconds) ++ ":" ++ (String.padLeft 2 '0' (toString seconds))

formatTime: Float -> String
formatTime seconds =
  let (hours, minutes) =
    ((round seconds) // 3600, ((round seconds) % 3600) // 60)
  in
    (String.padLeft 2 '0' (toString hours)) ++ ":" ++ (String.padLeft 2 '0' (toString minutes))

formatPlaybackPosition: Float -> Float -> String
formatPlaybackPosition position length =
  "(" ++ formatTime position ++ "/" ++ formatTime length ++ ")"

formatPlaybackPositionSeconds: Float -> Float -> String
formatPlaybackPositionSeconds position length =
  "(" ++ formatTimeSeconds position ++ "/" ++ formatTimeSeconds length ++ ")"

getBookById : Model.Model -> String -> Maybe Model.Audiobook
getBookById model id =
  (case model.playback.currentBook of
    Just id ->
      Dict.get id model.books
    _ ->
      Nothing)
