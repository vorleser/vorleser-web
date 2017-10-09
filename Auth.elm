module Auth exposing (..)
-- import Json.Decode exposing (..)
import Json.Encode as Encode
import Json.Decode as Decode

type alias LoginData =
    {
        name : String,
        password : String
    }

loginSchema : LoginData -> Encode.Value
loginSchema data =
    Encode.object [("name", Encode.string ""), ("password", Encode.string "")]
