module Config exposing (..)
name : String
name = "Vorleser"

baseUrl : String
baseUrl = "http://localhost:8000/"

-- interval in which to upload playstates
playstateUploadInterval : Float
playstateUploadInterval = 10
