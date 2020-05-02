port module Api exposing (Credential(..), application, login, logout, storeCredential, username, viewerChanges)

{- The Api module controls external communications.

   This is both with server-side resources and to the client env, e.g. localStorage.

-}

import Browser
import Browser.Navigation as Nav
import Dict exposing (Dict)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (optional, required)
import Json.Encode as Encode exposing (Value)
import Tokens exposing (Tokens)
import Url exposing (Url)
import Username exposing (Username(..))


type Credential
    = Credential Username Tokens


username : Credential -> Username
username (Credential uname _) =
    uname


port onStoreChange : (Value -> msg) -> Sub msg


viewerChanges : (Maybe viewer -> msg) -> Decoder (Credential -> viewer) -> Sub msg
viewerChanges toMsg decoder =
    onStoreChange (\value -> toMsg (decodeFromChange decoder value))


decodeFromChange : Decoder (Credential -> viewer) -> Value -> Maybe viewer
decodeFromChange viewerDecoder val =
    Decode.decodeValue (storageDecoder viewerDecoder) val
        |> Debug.log "Api.decodeFromChange"
        |> Result.toMaybe


credentialDecoder : Decoder Credential
credentialDecoder =
    Decode.succeed Credential
        |> required "username" Username.decoder
        |> required "tokens" Tokens.decoder


login : String -> Credential
login name =
    let
        uname =
            Username name

        -- using temporary (simplified) record
        tokens =
            { idToken = "id-abc"
            , refreshToken = "refresh-abc"
            , accessToken = "access-abc"
            }
    in
    Credential
        uname
        tokens


storeCredential : Credential -> Cmd msg
storeCredential (Credential uname tokens) =
    let
        json =
            Encode.object
                [ ( "user"
                  , Encode.object
                        [ ( "username", Username.encode uname )
                        , ( "tokens", Tokens.encode tokens )
                        ]
                  )
                ]
    in
    storeCache (Just json)


logout : Cmd msg
logout =
    Debug.log "logout" storeCache Nothing


port storeCache : Maybe Value -> Cmd msg


storageDecoder : Decoder (Credential -> viewer) -> Decoder viewer
storageDecoder viewerDecoder =
    Decode.field "user" (decoderFromCredential viewerDecoder)


decoderFromCredential : Decoder (Credential -> a) -> Decoder a
decoderFromCredential decoder =
    Decode.map2 (\fromCredential cred -> fromCredential cred)
        decoder
        credentialDecoder


application :
    Decoder (Credential -> viewer)
    ->
        { init : Maybe viewer -> Url -> Nav.Key -> ( model, Cmd msg )
        , update : msg -> model -> ( model, Cmd msg )
        , view : model -> Browser.Document msg
        , subscriptions : model -> Sub msg
        , onUrlChange : Url -> msg
        , onUrlRequest : Browser.UrlRequest -> msg
        }
    -> Program Value model msg
application viewerDecoder config =
    let
        init flags url navKey =
            let
                maybeViewer =
                    Decode.decodeValue Decode.string flags
                        |> Result.andThen (Decode.decodeString (storageDecoder viewerDecoder))
                        |> Result.toMaybe
            in
            config.init (Debug.log "maybeViewer" maybeViewer)
                (Debug.log "url" url)
                (Debug.log "navKey" navKey)
    in
    Browser.application
        { init = init
        , update = config.update
        , view = config.view
        , subscriptions = config.subscriptions
        , onUrlChange = config.onUrlChange
        , onUrlRequest = config.onUrlRequest
        }
