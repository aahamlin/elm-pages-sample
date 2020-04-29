module User.Username exposing (Username)


type Username
    = Username String


toString : Username -> String
toString (Username name) =
    name
