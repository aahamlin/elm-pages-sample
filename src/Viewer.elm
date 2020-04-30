module Viewer exposing (Viewer(..), decoder, store, username)

{- Module representing a user containing the Viewername and available auth Tokens

-}

import Api exposing (Credential)
import Json.Decode as Decode exposing (Decoder)
import Username exposing (Username)


type Viewer
    = Viewer Credential


username : Viewer -> Username
username (Viewer cred) =
    Api.username cred


store : Viewer -> Cmd msg
store (Viewer cred) =
    Api.storeCredential
        cred


decoder : Decoder (Credential -> Viewer)
decoder =
    Decode.succeed Viewer
