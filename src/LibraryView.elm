type alias LibraryView = {
    libraries: List Library,
    books: List Audiobook,
    chapters: List Chapter,
    playstates: List Playstate
}

type alias AllThingsResponse = {
    libraries: List Library,
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
    timestamp: String -- TODO: this should be a Date
}