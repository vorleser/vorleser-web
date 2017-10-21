module Api exposing (..)
import Auth
import Json.Decode
import Http
import Config
import Msg
import Model
import Json.Encode as Encode
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required)
import Model exposing (Audiobook, Playstate, AllThings)

login : String -> String -> Cmd Msg.Msg
login user password =
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
  Msg.AllData

getBooks : Model.Model -> Cmd Msg.Msg
getBooks model =
  Auth.get
  model
  "/audiobooks"
  (Decode.list audiobookDecoder)
  Msg.Books

allDecoder: Decode.Decoder AllThings
allDecoder =
    decode AllThings
        |> required "audiobooks" (Decode.list audiobookDecoder)
        |> required "playstates" (Decode.list playstateDecoder)

playstateDecoder: Decode.Decoder Playstate
playstateDecoder =
    decode Playstate
        |> required "audiobook_id" Decode.string
        |> required "position" Decode.float
        |> required "timestamp" Decode.string

audiobookDecoder: Decode.Decoder Audiobook
audiobookDecoder =
    decode Audiobook
        |> required "id" Decode.string
        |> required "title" Decode.string
        |> required "artist" (Decode.maybe Decode.string)
        |> required "length" Decode.float
        |> required "library_id" Decode.string
