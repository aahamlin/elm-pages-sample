module Page.Login exposing (..)

import Api exposing (Credential)
import Html exposing (Html, br, button, div, h1, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Route exposing (Route)
import Session exposing (Session)
import Task exposing (Task)
import Viewer exposing (Viewer(..))


type alias Model =
    { session : Session
    , problems : String
    }


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session
      , problems = ""
      }
    , Cmd.none
    )


type Msg
    = DoLogin
    | CompletedLogin (Result String Viewer)
    | GotSession Session


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Login"
    , content =
        div []
            [ div [ class "container my-md-4" ]
                [ h1 [] [ text "Login content" ]
                , button [ class "btn btn-primary btn-lg", onClick DoLogin ] [ text "Login" ]
                ]
            ]
    }


fakeLogin : String -> Task x (Result String Viewer)
fakeLogin usernameVal =
    let
        cred =
            Api.login usernameVal
    in
    Ok (Viewer cred)
        |> Task.succeed


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "Login.update" msg of
        DoLogin ->
            ( model
              -- elm/task seems to be the necessary magic to fake a login
              --Api.login CompletedLogin "bob"
            , Task.perform CompletedLogin (fakeLogin "bob")
            )

        CompletedLogin (Err err) ->
            ( { model | problems = err }
            , Cmd.none
            )

        CompletedLogin (Ok viewer) ->
            ( model
            , Viewer.store viewer
            )

        GotSession session ->
            ( { model | session = session }
              -- every subpage that should redirect to home when sessions change
            , Route.replaceUrl (Session.navKey session) Route.Home
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Session.changes GotSession (Session.navKey model.session)
