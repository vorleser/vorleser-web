port module Session exposing (..)
import Msg

port saveSession  : String -> Cmd msg
port getSession : (String -> msg) -> Sub msg

port saveServerUrl  : String -> Cmd msg
port getServerUrl : (String -> msg) -> Sub msg

port saveCurrentBook  : String -> Cmd msg
port getCurrentBook : (String -> msg) -> Sub msg
