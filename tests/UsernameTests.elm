module UsernameTests exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Json.Decode as Decode
import Json.Encode as Encode
import Test exposing (..)
import Username exposing (Username(..))


suite : Test
suite =
    describe "Username"
        [ testToString
        , testDecode
        , testEncode
        ]


testToString : Test
testToString =
    test "Username.toString" <|
        \_ ->
            Username "bob"
                |> Username.toString
                |> Expect.equal "bob"


testDecode : Test
testDecode =
    test "Username.decoder" <|
        \_ ->
            """{"username":"Billy"}"""
                |> Decode.decodeString
                    (Decode.field "username" Username.decoder)
                |> Expect.ok


testEncode : Test
testEncode =
    test "Username.encode" <|
        \_ ->
            Encode.object
                [ ( "username", Username.encode (Username "Billy") ) ]
                |> Encode.encode 0
                |> Expect.equal """{"username":"Billy"}"""
