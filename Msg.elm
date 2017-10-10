module Msg exposing (..)
import Http
import Auth
type LoginViewMsg = Submit | PasswordChange String | NameChange String
type Msg = Login (LoginViewMsg) | LoggedIn (Result Http.Error Auth.SessionSecret)

