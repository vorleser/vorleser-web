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

formatTime: Float -> String
formatTime seconds =
  let (hours, minutes) =
    ((round seconds) // 3600, ((round seconds) % 3600) // 60)
  in
    (String.padLeft 2 '0' (toString hours)) ++ ":" ++ (String.padLeft 2 '0' (toString minutes))

getBookById : Model.Model -> String -> Maybe Model.Audiobook
getBookById model id =
  (case model.playback.currentBook of
    Just id ->
      Dict.get id model.books
    _ ->
      Nothing)
