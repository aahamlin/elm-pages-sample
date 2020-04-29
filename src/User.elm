module User exposing (User, username)

{- Module representing a user containing the Username and available auth Tokens

-}

import User.Username exposing (Username)


type User
    = User Username Tokens



-- TODO the tokens as strings are only temporary


type alias Tokens =
    { idToken : String
    , refreshToken : String
    , accessToken : String
    }


username : User -> Username
username (User uname _) =
    uname
