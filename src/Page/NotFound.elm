module Page.NotFound exposing (view)

import Html exposing (Html, div, text)


view : { title : String, content : Html msg }
view =
    { title = "Page Not Found"
    , content =
        div [] [ text "Sorry, that page is not found." ]
    }
