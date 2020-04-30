module TokensTests exposing (..)

{- rename Tokens test -}

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Json.Decode as Decode
import Json.Encode as Encode
import Test exposing (..)
import Tokens exposing (Tokens)


suite : Test
suite =
    describe "Tokens"
        [ test "serialization" <|
            {- Test round-trip serialization of our tokens.

               This data type crosses our application boundary over our ports,
               from Elm to Javascript (localStorage) and back again, so we
               want to be sure we can decode what we previously encoded.
            -}
            \_ ->
                let
                    tokens =
                        { idToken = "id-token-1234"
                        , refreshToken = "refresh-token-1234"
                        , accessToken = "access-token-1234"
                        }
                in
                Tokens.encode tokens
                    -- necessary intermediary step from Encode.Value to Decode.Value
                    |> Encode.encode 0
                    |> Decode.decodeString Tokens.decoder
                    |> Expect.ok
        ]
