module Username exposing (Username(..), decoder, encode, toString)

import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode exposing (Value)


type Username
    = Username String


decoder : Decoder Username
decoder =
    Decode.map Username Decode.string


encode : Username -> Value
encode (Username uname) =
    Encode.string uname


toString : Username -> String
toString (Username name) =
    name
