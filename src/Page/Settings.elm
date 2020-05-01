module Page.Settings exposing (..)

import Html exposing (Html, div, text)
import Route exposing (Route)
import Session exposing (Session)


type alias Model =
    { session : Session
    }


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session
      }
    , Cmd.none
    )


type Msg
    = GotSession Session


view : Model -> { title : String, content : Html msg }
view model =
    { title = "Settings"
    , content =
        div [] [ text "Settings content" ]
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
