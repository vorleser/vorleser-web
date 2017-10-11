module Model exposing (..)

type View = LoginView | LibraryView

type alias Model = {
    login_view: LoginViewModel,
    login_token: Maybe String,
    current_view: View
}


type alias LoginViewModel = {
    name : String,
    password : String
}

