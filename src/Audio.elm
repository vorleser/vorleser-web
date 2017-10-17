port module Audio exposing (..)
import Msg

type alias Playback = {
    file: String
  , progress: Float
}

type Command = Play (String) | Pause | Unpause | SkipTo (Float) | Toggle
type alias JsCommand =
  { command : String
  , arg : Maybe String
  }

toJs : Command -> JsCommand
toJs command =
  case command of
    Play name ->
      { command = "Play", arg = Just name }
    Pause ->
      { command = "Pause", arg = Nothing }
    Unpause ->
      { command = "Unpause", arg = Nothing }
    Toggle ->
      { command = "Toggle", arg = Nothing }
    SkipTo num ->
      { command = "SkipTo", arg = Just (toString num) }


port command  : JsCommand -> Cmd msg
port progress : (Float -> msg) -> Sub msg
