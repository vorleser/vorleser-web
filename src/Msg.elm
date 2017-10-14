module Msg exposing (..)
import Http
import Auth
import Material
import Material.Snackbar as Snackbar

type LoginViewMsg = Submit | PasswordChange String | NameChange String
type Msg
  = Login (LoginViewMsg)
  | LoggedIn (Result Http.Error Auth.SessionSecret)
  | Mdl (Material.Msg Msg)
  | RequestBooks
  | Books (Result Http.Error String)
  | Snackbar (Snackbar.Msg String)
