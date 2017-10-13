module Auth exposing (..)
-- import Json.Decode exposing (..)
import Json.Encode as Encode
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required)
import Config
import Http
import Model

type alias LoginData =
    {
        email : String,
        password : String
    }

type alias SessionSecret =
    {
        secret : String
    }

loginEncoder : LoginData -> Encode.Value
loginEncoder data =
    Encode.object [("email", Encode.string data.email), ("password", Encode.string data.password)]

sessionSecretDecoder : Decode.Decoder SessionSecret
sessionSecretDecoder =
    decode SessionSecret
        |> required "secret" Decode.string

authenticatedGet :
    Model.Model
    -> String
    -> Decode.Decoder a
    -> (Result Http.Error a -> msg)
    -> Cmd msg
authenticatedGet model url decoder msg =
    authenticatedApiCall "GET" model url decoder msg

authenticatedApiCall :
    String
    -> Model.Model
    -> String
    -> Decode.Decoder a
    -> (Result Http.Error a -> msg)
    -> Cmd msg
authenticatedApiCall method model url decoder msg =
    case model.loginToken of
        Just secret ->
            let
                request =
                    Http.request
                        {
                          method = method,
                          headers = [ Http.header "Authorization:" secret ],
                          url = Config.baseUrl ++ url,
                          expect = Http.expectJson decoder,
                          body = Http.emptyBody,
                          timeout = Nothing,
                          withCredentials = False
                        }
            in
                Http.send msg request

        _ ->
            Debug.log "Token required for authenticated request" Cmd.none
