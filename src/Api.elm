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
import Model exposing (Audiobook)

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

get_everything : Model.Model -> Cmd Msg.Msg
get_everything model =
  Auth.get
  model
  "/all_the_things"
  Json.Decode.string
  Msg.Books

getBooks : Model.Model -> Cmd Msg.Msg
getBooks model =
  Auth.get
  model
  "/audiobooks"
  (Json.Decode.list audiobookDecoder)
  Msg.Books

-- {(Auth.authenticatedGet "/all_the_things")}

audiobookDecoder: Decode.Decoder Audiobook
audiobookDecoder =
    decode Audiobook
        |> required "id" Decode.string
        |> required "title" Decode.string
        |> required "artist" (Decode.maybe Decode.string)
        |> required "length" Decode.float
        |> required "library_id" Decode.string
