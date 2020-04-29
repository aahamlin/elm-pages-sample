module Page.Home exposing (..)

import Html exposing (Html, div, text)
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
        div [] [ text "Homepage content" ]
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( GotSession session, _ ) ->
            ( { model | session = session }, Cmd.none )
