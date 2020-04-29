module Example exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Route exposing (Route(..))
import Test exposing (..)
import Url exposing (Url)


fromUrl : Test
fromUrl =
    describe "Route.fromUrl"
        [ testUrl "" Home
        , testUrl "login" Login
        , testUrl "settings" Settings
        , testNotFoundUrl "abcefghijklmnop"
        ]


testNotFoundUrl : String -> Test
testNotFoundUrl hash =
    test ("Parsing non-existent hash \"" ++ hash ++ "\"") <|
        \() ->
            urlFragment hash
                |> Route.fromUrl
                |> Expect.equal Nothing


testUrl : String -> Route -> Test
testUrl hash route =
    test ("Parsing hash \"" ++ hash ++ "\"") <|
        \() ->
            urlFragment hash
                |> Route.fromUrl
                |> Expect.equal (Just route)


urlFragment : String -> Url
urlFragment str =
    { protocol = Url.Http
    , host = "null.com"
    , port_ = Nothing
    , path = "/"
    , query = Nothing
    , fragment = Just str
    }
