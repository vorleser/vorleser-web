module Api exposing (..)
import Auth
import Json.Decode
import Http
import Config
import Msg
import Model

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
  (Config.baseUrl ++ "/all_the_things")
  Json.Decode.string
  Msg.Books

-- {(Auth.authenticatedGet "/all_the_things")}
