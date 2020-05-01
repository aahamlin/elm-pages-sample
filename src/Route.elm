module Route exposing (Route(..), fromUrl, href, replaceUrl)

import Browser.Navigation as Nav
import Html exposing (Attribute)
import Html.Attributes as Attr
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, oneOf, s, string)


type Route
    = Root
    | Home
    | Login
    | Logout
    | Settings


parser : Parser (Route -> a) a
parser =
    {- Parse all known routes.

       This requires a unit test for completeness.
    -}
    oneOf
        [ Parser.map Home Parser.top
        , Parser.map Login (s "login")
        , Parser.map Logout (s "logout")
        , Parser.map Settings (s "settings")
        ]


href : Route -> Attribute msg
href targetRoute =
    Attr.href (routeToString targetRoute)


fromUrl : Url -> Maybe Route
fromUrl url =
    { url | path = Maybe.withDefault "" url.fragment, fragment = Nothing }
        |> Parser.parse parser


replaceUrl : Nav.Key -> Route -> Cmd msg
replaceUrl navKey route =
    Nav.replaceUrl navKey (routeToString route)


routeToString : Route -> String
routeToString route =
    "#/"
        ++ String.join "/"
            (routeToParts route)


routeToParts : Route -> List String
routeToParts route =
    case route of
        Root ->
            []

        Home ->
            []

        Login ->
            [ "login" ]

        Logout ->
            [ "logout" ]

        Settings ->
            [ "settings" ]
