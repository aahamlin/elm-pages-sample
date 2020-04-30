module Session exposing (Session, changes, fromViewer, navKey, viewer)

import Api
import Browser.Navigation as Nav
import Viewer exposing (Viewer)



{- Session module represents a client-side "session".

   This contains either a logged in user or a guest.

-}


type Session
    = LoggedIn Nav.Key Viewer
    | Guest Nav.Key


viewer : Session -> Maybe Viewer
viewer session =
    case session of
        LoggedIn _ val ->
            Just val

        Guest _ ->
            Nothing


navKey : Session -> Nav.Key
navKey session =
    case session of
        LoggedIn key _ ->
            key

        Guest key ->
            key



-- toViewer : Nav.Key -> Maybe Viewer -> Session
-- toViewer key maybeViewer =
--     case maybeViewer of
--         Just val ->
--             LoggedIn key val
--         Nothing ->
--             Guest key


changes : (Session -> msg) -> Nav.Key -> Sub msg
changes toMsg key =
    Api.viewerChanges (\maybeViewer -> toMsg (fromViewer key maybeViewer)) Viewer.decoder


fromViewer : Nav.Key -> Maybe Viewer -> Session
fromViewer key maybeViewer =
    case Debug.log "Session.fromViewer" maybeViewer of
        Just aViewer ->
            LoggedIn key aViewer

        Nothing ->
            Guest key
