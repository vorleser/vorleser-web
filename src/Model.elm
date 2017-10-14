module Model exposing (..)
import Material
import Material.Snackbar as Snackbar

type View = LoginView | BookListView

type alias Mdl =
    Material.Model

type alias Model = {
    loginView: LoginViewModel,
    loginToken: Maybe String,
    currentView: View,
    mdl: Material.Model,
    data: String,
    snackbar: Snackbar.Model String
}


type alias LoginViewModel = {
    name : String,
    password : String
}
