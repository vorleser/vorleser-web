module Msg exposing (..)
import Http
import Auth
import Material
import Material.Snackbar as Snackbar
import Model exposing (..)
import Date

type LoginViewMsg = Submit | PasswordChange String | NameChange String
type Msg
  = Login (LoginViewMsg)
  | LoggedIn (Result Http.Error Auth.SessionSecret)
  | Books (Result Http.Error (List Audiobook))
  | Mdl (Material.Msg Msg)
  | RequestBooks
  | Snackbar (Snackbar.Msg String)
  | PlayBook (String)
  | SetProgressManually (Float)
  | SetProgress (Float)
  | TogglePlayback
  | SetPlaying (Bool)
  | AllData (Result Http.Error AllThings)
  | UpdatedPlaystates (Result Http.Error String)
  | UpdateLocalPlaystate (Date.Date)
