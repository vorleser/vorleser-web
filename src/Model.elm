module Model exposing (..)
import Material

type View = LoginView | LibraryView

type alias Mdl =
    Material.Model

type alias Model = {
    login_view: LoginViewModel,
    login_token: Maybe String,
    current_view: View,
    mdl: Material.Model
}


type alias LoginViewModel = {
    name : String,
    password : String
}

