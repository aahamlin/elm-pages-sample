module Page exposing (..)

import Browser exposing (Document)
import Html exposing (Html, a, div, footer, i, li, nav, text, ul)
import Html.Attributes exposing (class, classList, href, style)
import Route exposing (Route)
import Viewer exposing (Viewer)


type Page
    = Other
    | Home
    | Login
    | Settings


view : Maybe Viewer -> Page -> { title : String, content : Html msg } -> Document msg
view maybeViewer page { title, content } =
    { title = title ++ " - Pages Sample"
    , body = viewHeader page maybeViewer :: content :: [ viewFooter ]
    }


viewHeader : Page -> Maybe Viewer -> Html msg
viewHeader page maybeViewer =
    nav [ class "navbar navbar-light" ]
        [ div [ class "container" ]
            [ a [ class "navbar-brand", Route.href Route.Home ]
                [ text "Pages Sample" ]
            , ul [ class "nav navbar-nav pull-xs-right" ] <|
                navbarLink page Route.Home [ text "Home" ]
                    :: viewMenu page maybeViewer
            ]
        ]


viewFooter : Html msg
viewFooter =
    footer []
        [ div [] [ text "viewFooter" ]
        ]


viewMenu : Page -> Maybe Viewer -> List (Html msg)
viewMenu page maybeViewer =
    let
        linkTo =
            navbarLink page
    in
    case maybeViewer of
        Just user ->
            let
                username =
                    Viewer.username user
            in
            [ linkTo Route.Settings [ i [ class "ion-gear-a" ] [], text "\u{00A0}Settings" ]
            , linkTo Route.Logout [ text "Sign out" ]
            ]

        Nothing ->
            [ linkTo Route.Login [ text "Sign in" ]
            ]


navbarLink : Page -> Route -> List (Html msg) -> Html msg
navbarLink page route linkContent =
    li []
        [ a [ class "nav-link", Route.href route ] linkContent ]
