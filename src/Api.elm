module Api exposing (..)
import Auth
import Json.Decode
import Http
import Config
import Msg
import Model
import Dict
import Json.Encode as Encode
import Json.Decode as Decode
import Json.Encode.Extra as EncodeExtra
import Json.Decode.Extra as DecodeExtra
import Json.Decode.Pipeline exposing (decode, required, optional)
import Date.Extra as DateExtra
import Model exposing (Audiobook, Playstate, AllThings, Chapter)

login : String -> String -> String -> Cmd Msg.Msg
login user password serverUrl =
  let loginData =
        { email = user, password = password}
  in
      let request =
            Http.post (Config.baseUrl ++ "/auth/login")
            (Http.jsonBody <| Auth.loginEncoder loginData)
            Auth.sessionSecretDecoder
      in
          Http.send Msg.LoggedIn request

getEverything : Model.Model -> Cmd Msg.Msg
getEverything model =
  Auth.get
  model
  "/all_the_things"
  allDecoder
  Msg.ReceiveAllData

getBooks : Model.Model -> Cmd Msg.Msg
getBooks model =
  Auth.get
  model
  "/audiobooks"
  (Decode.list audiobookDecoder)
  Msg.ReceiveBooks

allDecoder: Decode.Decoder AllThings
allDecoder =
    decode AllThings
        |> required "books" (Decode.list audiobookDecoder)
        |> required "chapters" (Decode.list chapterDecoder)
        |> required "playstates" (Decode.list playstateDecoder)

chapterDecoder: Decode.Decoder Chapter
chapterDecoder =
    decode Chapter
        |> required "id" Decode.string
        |> required "title" (Decode.maybe Decode.string)
        |> required "number" Decode.int
        |> required "start_time" Decode.float
        |> required "audiobook_id" Decode.string

playstateDecoder: Decode.Decoder Playstate
playstateDecoder =
    decode Playstate
        |> required "audiobook_id" Decode.string
        |> required "position" Decode.float
        |> required "timestamp" DecodeExtra.date

audiobookDecoder: Decode.Decoder Audiobook
audiobookDecoder =
    decode Audiobook
        |> required "id" Decode.string
        |> required "title" Decode.string
        |> required "artist" (Decode.maybe Decode.string)
        |> required "length" Decode.float
        |> required "library_id" Decode.string

playstateEncode: Playstate -> Encode.Value
playstateEncode state =
  Encode.object
  [ ("audiobook_id", Encode.string state.audiobook_id)
  , ("position", Encode.float state.position)
  , ("timestamp", Encode.string (DateExtra.toIsoString state.timestamp))
  ]

updatePlaystates: Model.Model -> Cmd Msg.Msg
updatePlaystates model =
  Auth.post
  model
  "/update_playstates"
  Decode.value
  (
    Encode.list
    (List.map
      (\s -> (playstateEncode (Tuple.second s)))
      (Dict.toList model.playstates)
    )
  )
  Msg.UpdatedPlaystates
