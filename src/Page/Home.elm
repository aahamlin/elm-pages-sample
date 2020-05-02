module Page.Home exposing (..)

import Html exposing (Html, div, h1, p, text)
import Html.Attributes exposing (class)
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
    { title = "Home"
    , content =
        div [ class "container my-md-4" ]
            [ h1 [] [ text "Homepage content" ]
            , p [] [ text "homepage content viewable by users & guests." ]
            ]
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( GotSession session, _ ) ->
            ( { model | session = session }
            , Route.replaceUrl (Session.navKey session) Route.Home
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Session.changes GotSession (Session.navKey model.session)
