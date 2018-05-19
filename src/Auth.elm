module Auth exposing (..)
import Json.Encode as Encode
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required)
import Config
import Http
import Model
import Util

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
post model url decoder body msg =
    authenticatedApiCall "POST" model url decoder (Http.jsonBody body) msg

postEmptyResponse :
    Model.Model
    -> String
    -> Encode.Value
    -> (Result Http.Error () -> msg)
    -> Cmd msg
postEmptyResponse model url body msg =
    authenticatedApiCallEmptyResponse "POST" model url (Http.jsonBody body) msg

get :
    Model.Model
    -> String
    -> Decode.Decoder a
    -> (Result Http.Error a -> msg)
    -> Cmd msg
get model url decoder msg =
    authenticatedApiCall "GET" model url decoder Http.emptyBody msg

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
                          url = (Util.baseUrl model.serverUrl) ++ url,
                          expect = Http.expectJson decoder,
                          body = body,
                          timeout = Nothing,
                          withCredentials = False
                        }
            in
                Http.send msg request

        _ ->
            Debug.log "Token required for authenticated request" Cmd.none

authenticatedApiCallEmptyResponse :
    String
    -> Model.Model
    -> String
    -> Http.Body
    -> (Result Http.Error () -> msg)
    -> Cmd msg

authenticatedApiCallEmptyResponse method model url body msg =
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
                          url = (Util.baseUrl model.serverUrl) ++ url,
                          expect = Http.expectStringResponse (\lol -> Ok ()),
                          body = body,
                          timeout = Nothing,
                          withCredentials = False
                        }
            in
                Http.send msg request

        _ ->
            Debug.log "Token required for authenticated request" Cmd.none
