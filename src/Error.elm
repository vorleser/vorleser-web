module Error exposing (..)
import Http
import Msg
import Model
import Material.Snackbar as Snackbar

handleHttpError :  Http.Error -> String -> Model.Model -> (Model.Model, Cmd Msg.Msg)
handleHttpError error resource model =
  case error of
    Http.BadPayload info _ ->
      Debug.log info
        (errorSnackbar model "" ("Error " ++  resource ++ ", got an unexpected payload."))
    Http.NetworkError ->
      (errorSnackbar model "" ("Error " ++ resource ++ ", check your network connection."))
    Http.BadStatus text ->
      (errorSnackbar model "" ("Error " ++ resource ++ ". Bad status code"))
    Http.Timeout ->
      (errorSnackbar model "" ("Timeout " ++ resource))
    Http.BadUrl _ ->
      (errorSnackbar model "" "Bad url, how does this even happen?")

errorSnackbar : Model.Model -> String -> String -> (Model.Model, Cmd Msg.Msg)
errorSnackbar model text name =
  (Tuple.mapSecond (Cmd.map Msg.Snackbar)
  (Tuple.mapFirst (\first -> { model | snackbar = first })
    (Snackbar.add (Snackbar.toast text name) model.snackbar)
  ))

