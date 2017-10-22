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

post :
    Model.Model
    -> String
    -> Decode.Decoder a
    -> Encode.Value
    -> (Result Http.Error a -> msg)
    -> Cmd msg
post token url decoder body msg =
    authenticatedApiCall "POST" token url decoder (Http.jsonBody body) msg

get :
    Model.Model
    -> String
    -> Decode.Decoder a
    -> (Result Http.Error a -> msg)
    -> Cmd msg
get token url decoder msg =
    authenticatedApiCall "GET" token url decoder Http.emptyBody msg

authenticatedApiCall :
    String
    -> Model.Model
    -> String
    -> Decode.Decoder a
    -> Http.Body
    -> (Result Http.Error a -> msg)
    -> Cmd msg

authenticatedApiCall method model url decoder body msg =
    case model.loginToken of
        Just secret ->
            let
                request =
                    Http.request
                        {
                          method = method,
                          headers =
                            [ Http.header "Authorization" secret
                            ],
                          url = Config.baseUrl ++ url,
                          expect = Http.expectJson decoder,
                          body = body,
                          timeout = Nothing,
                          withCredentials = False
                        }
            in
                Http.send msg request

        _ ->
            Debug.log "Token required for authenticated request" Cmd.none
