module Model exposing (..)
import Material

type View = LoginView | BookListView

type alias Mdl =
    Material.Model

type alias Model = {
    loginView: LoginViewModel,
    loginToken: Maybe String,
    currentView: View,
    mdl: Material.Model,
    data: String
}


type alias LoginViewModel = {
    name : String,
    password : String
}

