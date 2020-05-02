module Page exposing (..)

import Browser exposing (Document)
import Html exposing (Html, a, div, footer, h1, hr, i, li, nav, p, small, span, text, ul)
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
    , body =
        viewHeader page maybeViewer
            :: content
            :: [ viewFooter ]
    }


viewHeader : Page -> Maybe Viewer -> Html msg
viewHeader page maybeViewer =
    nav [ class "navbar navbar-dark bg-primary navbar-expand-sm" ]
        [ div [ class "container" ]
            [ div [ class "navbar-header" ]
                [ a [ class "navbar-brand", Route.href Route.Home ]
                    [ text "Pages" ]
                ]
            , ul [ class "nav navbar-nav navbar-right" ] <|
                navbarLink page Route.Home [ text "Home" ]
                    :: viewMenu page maybeViewer
            ]
        ]


viewFooter : Html msg
viewFooter =
    div [ class "container" ]
        [ hr [ class "bg-secondary" ] []
        , p []
            [ small []
                [ text "A sample of page navigation, based on "
                , a [ href "https://github.com/rtfeldman/elm-spa-example" ]
                    [ text "elm-spa-example" ]
                , text ". Code & design licensed under MIT."
                ]
            ]
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
            [ linkTo Route.Settings [ text "Settings" ]
            , linkTo Route.Logout [ text "Sign out" ]
            ]

        Nothing ->
            [ linkTo Route.Login [ text "Sign in" ]
            ]


navbarLink : Page -> Route -> List (Html msg) -> Html msg
navbarLink page route linkContent =
    li [ classList [ ( "nav-item", True ), ( "active", isActive page route ) ] ]
        [ a [ class "nav-link", Route.href route ] linkContent ]


isActive : Page -> Route -> Bool
isActive page route =
    case ( page, route ) of
        ( Home, Route.Home ) ->
            True

        ( Login, Route.Login ) ->
            True

        ( Settings, Route.Settings ) ->
            True

        _ ->
            False
