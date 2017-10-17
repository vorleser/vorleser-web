port module Audio exposing (..)
import Msg

type alias Playback = {
    file: String
  , progress: Float
}

type Command = Play (String) | Pause | Unpause | Skip (Float)
port command  : String -> Cmd msg
port progress : (Playback -> msg) -> Sub msg
