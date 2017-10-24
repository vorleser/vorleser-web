module Model exposing (..)
import Material
import Material.Snackbar as Snackbar
import Dict exposing (Dict)
import Date

type View = LoginView | BookListView

type alias Mdl =
    Material.Model

type alias Model = {
    loginView: LoginViewModel
  , loginToken: Maybe String
  , currentView: View
  , mdl: Material.Model
  , books: Dict String Audiobook
  , playstates: Dict String Playstate
  , chapters: Dict String Chapter
  , snackbar: Snackbar.Model String
  , playback: Playback
}

type alias Playback = {
    currentBook: Maybe String
  , progress: Float
  , playing: Bool
  , hasPlayed: Bool
}


type alias LoginViewModel = {
    name : String,
    password : String
}

type alias LibraryView = {
    libraries: List Library,
    books: List Audiobook,
    chapters: List Chapter,
    playstates: List Playstate
}

type alias AllThings = {
    -- libraries: List Library,
    books: List Audiobook,
    chapters: List Chapter,
    playstates: List Playstate
}

type alias Library = {
    id: String
}

type alias Audiobook = {
    id: String,
    title: String,
    artist: Maybe String,
    length: Float,
    library_id: String
}

type alias Chapter = {
    id: String,
    title: Maybe String,
    number: Int,
    start_time: Float,
    audiobook_id: String
}

type alias Playstate = {
    audiobook_id: String,
    position: Float,
    timestamp: Date.Date -- TODO: this should be a Date
}

-- getBookById : String -> Model -> Audiobook
-- getBookById id model =
--   List.find (\book -> book.id == id) model.books
