module Page.Home exposing (..)

import Html exposing (Html, div, h1, p, text)
import Html.Attributes exposing (class)
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



-- viewBanner : Html msg
-- viewBanner =
--     div [ class "jumbotron" ]
--         [ div [ class "container" ]
--             [ h1 [ class "display-4" ] [ text "Pages" ]
--             , p [ class "lead" ] [ text "sample page navigation in elm" ]
--             ]
--         ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( GotSession session, _ ) ->
            ( { model | session = session }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Session.changes GotSession (Session.navKey model.session)
