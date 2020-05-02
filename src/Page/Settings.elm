module Page.Settings exposing (..)

import Html exposing (Html, div, h1, p, text)
import Html.Attributes exposing (class)
import Route exposing (Route(..))
import Session exposing (Session)
import Strings


type alias Model =
    { session : Session
    , errorMessage : String
    , returnRoute : Maybe Route
    }



{- Initialize the Settings page.

   This is a protected resource. An unauthenticated user cannot see it.
   Just one of many options on how to handle this case. Could benefit
   from a warning message, such as problems field in the model to display
   on the Home page -or- just display a message during Settings.view

-}


init : Session -> ( Model, Cmd Msg )
init session =
    let
        maybeViewer =
            Session.viewer session
    in
    case maybeViewer of
        Just _ ->
            ( { session = session
              , errorMessage = ""
              , returnRoute = Nothing
              }
            , Cmd.none
            )

        Nothing ->
            ( { session = session
              , errorMessage = Strings.unauthorizedError
              , returnRoute = Just Route.Settings
              }
            , Route.replaceUrl (Session.navKey session) Route.Login
            )


type Msg
    = GotSession Session


view : Model -> { title : String, content : Html msg }
view model =
    { title = "Settings"
    , content =
        div []
            [ div [ class "container my-md-4" ]
                [ h1 [] [ text "Settings content" ]
                , p [] [ text "fill in user settings page" ]
                ]
            ]
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "Settings.update" ( msg, model ) of
        ( GotSession session, _ ) ->
            ( { model | session = session }
            , Route.replaceUrl (Session.navKey session) Route.Home
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Session.changes GotSession (Session.navKey model.session)
