port module Session exposing (..)
import Model
import Msg

port saveSession  : String -> Cmd msg
port getSession : (String -> msg) -> Sub msg

port startupInfo  : (Model.StartupInfo -> msg) -> Sub msg

port saveServerUrl  : String -> Cmd msg
port getServerUrl : (String -> msg) -> Sub msg

port saveCurrentBook  : String -> Cmd msg
port getCurrentBook : (String -> msg) -> Sub msg

port saveLastPlayed : String -> Cmd msg
port requestLastPlayed : () -> Cmd msg
port getLastPlayed : (String -> msg) -> Sub msg
