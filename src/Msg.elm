module Msg exposing (..)
import Http
import Auth
import Material

type LoginViewMsg = Submit | PasswordChange String | NameChange String
type Msg = Login (LoginViewMsg) | LoggedIn (Result Http.Error Auth.SessionSecret) | Mdl (Material.Msg Msg) | RequestBooks | Books (Result Http.Error String)

