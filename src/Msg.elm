module Msg exposing (..)
import Http
import Auth
import Material
import Material.Snackbar as Snackbar
import Model exposing (..)
import Date
import Json.Decode

type LoginViewMsg = Submit | PasswordChange String | NameChange String

type PlaybackMsg
  = TogglePlayback
  | UpdateLocalPlaystate (Date.Date)
  | UpdateRemotePlaystates
  | UpdateProgress (Float)
  | SetPlaying (Bool)
  | SetVolume (Float)
  | PlayBook (String)
  | BookReadyAt (Float)
  | SetProgressManually (Float)

type Msg
  = Mdl (Material.Msg Msg)
  | Login (LoginViewMsg)
  | LoggedIn (Result Http.Error Auth.SessionSecret)
  | RequestBooks
  | RequestEverything
  | ReceiveAllData (Result Http.Error AllThings)
  | ReceiveBooks (Result Http.Error (List Audiobook))
  | Snackbar (Snackbar.Msg String)
  | UpdatedPlaystates (Result Http.Error Json.Decode.Value)
  | Playback (PlaybackMsg)
