module Util exposing (..)

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
