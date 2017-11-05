port module Session exposing (..)
import Msg

-- port getSession  : () -> Cmd msg
port saveSession  : String -> Cmd msg
port getSession : (String -> msg) -> Sub msg

