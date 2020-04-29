module Session exposing (Session, fromUser, navKey, toUser, user)

import Browser.Navigation as Nav
import User exposing (User)



{- Session module represents a client-side "session".

   This contains either a logged in user or a guest.

-}


type Session
    = LoggedIn Nav.Key User
    | Guest Nav.Key


user : Session -> Maybe User
user session =
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


toUser : Nav.Key -> Maybe User -> Session
toUser key maybeUser =
    case maybeUser of
        Just val ->
            LoggedIn key val

        Nothing ->
            Guest key


fromUser : Nav.Key -> Maybe User -> Session
fromUser key maybeUser =
    case maybeUser of
        Just aUser ->
            LoggedIn key aUser

        Nothing ->
            Guest key
