module Model exposing (..)
import Material
import Material.Snackbar as Snackbar
import Dict exposing (Dict)
import Date
import PlaybackBehaviour exposing (PlaybackBehaviour)

type View = MainView | LoginView | BookListView

type alias Mdl =
    Material.Model

type alias Model = {
    loginView: LoginViewModel
  , loginToken: Maybe String
  , currentView: View
  , serverUrl: String
  , mdl: Material.Model
  , books: Dict String Audiobook
  , playstates: Dict String Playstate
  , chapters: Dict String (List Chapter)
  , snackbar: Snackbar.Model String
  , playbackView: PlaybackView
  , playback: Playback
}

type alias PlaybackView = {
  expanded: Bool
}

type alias Playback = {
    currentBook: Maybe String
  , progress: Float
  , playing: Bool
  , hasPlayed: Bool
  , volume: Float
  , playbackBehaviour: PlaybackBehaviour -- indicates if we are waiting for the playback element and should start playing once ready
}

type alias LoginViewModel = {
    serverUrl : String,
    hideUrlField: Bool,
    name : String,
    password : String,
    error: Maybe String
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
    timestamp: Date.Date
}

-- getBookById : String -> Model -> Audiobook
-- getBookById id model =
--   List.find (\book -> book.id == id) model.books

type alias StartupInfo = {
    loginToken: String,
    serverUrl: String
}
