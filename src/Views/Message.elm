module Views.Message exposing (MessageType(..), messageView)

import Html exposing (Attribute, Html, div, text)
import Html.Attributes exposing (style)


type MessageType
    = Success
    | Warning


baseStyles : List (Attribute msg)
baseStyles =
    [ style "border-style" "solid"
    , style "border-width" "1px"
    , style "border-radius" "2px"
    , style "margin-top" "8px"
    , style "padding" "1em 1.5em"
    ]


warnStyles : List (Attribute msg)
warnStyles =
    [ style "border-color" "#c9ba9b"
    , style "background-color" "#fffaf3"
    , style "color" "#794b02"
    ]


messageView : String -> MessageType -> Html msg
messageView txtMessage messType =
    if txtMessage == "" then
        text ""

    else
        div
            (case messType of
                Warning ->
                    baseStyles ++ warnStyles

                Success ->
                    baseStyles
            )
            [ text txtMessage ]
