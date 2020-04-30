module Tokens exposing (Tokens, decoder, encode)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (optional, required)
import Json.Encode as Encode exposing (Value)



{- Module for managing encoding and decoding of tokens (from AWS Cognito).
   an id or access token includes a jwtToken and a payload.
   the payload includes valuable info such as the expiration time.

   Come back and add support for the payload, such as:
   required "payload" (Decode.dict Decode.value)
-}


type alias Tokens =
    { idToken : String -- JwtToken
    , refreshToken : String --Token
    , accessToken : String --JwtToken
    }



-- type alias JwtToken =
--     { jwtToken : String
--     , payload : Dict String Value
--     }
-- type alias Token =
--     { token : String }


decoder : Decoder Tokens
decoder =
    Decode.succeed Tokens
        |> required "idToken" Decode.string
        --jwtTokenDecoder
        |> required "refreshToken" Decode.string
        --tokenDecoder
        |> required "accessToken" Decode.string



-- decoderOfToken : Decoder Token
-- decoderOfToken =
--     Decode.succeed Token
--         |> required "token" Decode.string
-- decoderOfJwtToken : Decoder JwtToken
-- decoderOfJwtToken =
--     Decode.succeed JwtToken
--         |> required "jwtToken" Decode.string


encode : Tokens -> Value
encode tokens =
    Encode.object
        [ ( "idToken"
            --, Encode.object [ ( "jwtToken", Encode.string tokens.idToken ) ]
          , Encode.string tokens.idToken
            --(jwtTokenToString tokens.idToken)
          )
        , ( "refreshToken"
          , Encode.string tokens.refreshToken
            --(tokenToString tokens.refreshToken)
          )
        , ( "accessToken"
          , Encode.string tokens.accessToken
            --(jwtTokenToString tokens.accessToken)
          )
        ]
