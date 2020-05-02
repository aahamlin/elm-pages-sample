module Page.NotFound exposing (view)

import Html exposing (Html, div, h1, p, text)
import Html.Attributes exposing (class)


view : { title : String, content : Html msg }
view =
    { title = "Page Not Found"
    , content =
        div [ class "container my-md-4" ]
            [ h1 [] [ text "Page Not Found" ]
            , p [] [ text "Sorry, that page is not found." ]
            ]
    }
