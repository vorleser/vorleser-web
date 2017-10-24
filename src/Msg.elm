module Msg exposing (..)
import Http
import Auth
import Material
import Material.Snackbar as Snackbar
import Model exposing (..)
import Date

type LoginViewMsg = Submit | PasswordChange String | NameChange String

type PlaybackMsg
  = TogglePlayback
  | UpdateLocalPlaystate (Date.Date)
  | SetProgress (Float)
  | SetPlaying (Bool)
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
  | UpdatedPlaystates (Result Http.Error String)
  | Playback (PlaybackMsg)
