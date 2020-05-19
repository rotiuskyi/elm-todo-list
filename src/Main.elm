module Main exposing (main)

import Browser
import Html exposing (Html, div, form, h3, input, li, node, text, ul)
import Html.Attributes exposing (href, rel, style, value)
import Html.Events exposing (onClick, onInput, onSubmit)
import SemanticUI.Elements.Button as Button
import SemanticUI.Elements.Icon as Icon
import SemanticUI.Elements.Input as Input
import Set exposing (Set)
import Views.Message exposing (MessageType(..), messageView)


type alias Model =
    { tasks : List String
    , taskDraft : String
    , tasksDone : Set Int
    , warnMessage : String
    }


type Message
    = CreateTask
    | ChangeTaskDraft String
    | MarkTaskDone Int


main =
    Browser.sandbox { init = init, update = update, view = view }


init : Model
init =
    { tasks = []
    , taskDraft = ""
    , tasksDone = Set.empty
    , warnMessage = ""
    }


update : Message -> Model -> Model
update msg model =
    case msg of
        CreateTask ->
            if model.taskDraft == "" then
                { model | warnMessage = "Type task before creating." }

            else
                { model | tasks = model.taskDraft :: model.tasks, taskDraft = "" }

        ChangeTaskDraft newValue ->
            { model | taskDraft = newValue, warnMessage = "" }

        MarkTaskDone ndx ->
            { model
                | tasksDone =
                    if Set.member ndx model.tasksDone then
                        Set.remove ndx model.tasksDone

                    else
                        Set.insert ndx model.tasksDone
            }


view : Model -> Html Message
view model =
    div
        [ style "margin" "0 auto"
        , style "max-width" "768px"
        ]
        [ node "link" [ rel "stylesheet", href "https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.2.9/semantic.min.css" ] []
        , h3 [] [ text "Task List" ]
        , Html.form [ onSubmit CreateTask ]
            [ Input.input
                (let
                    conf =
                        Input.init
                 in
                 { conf | attributes = [ value model.taskDraft, onInput ChangeTaskDraft ] }
                )
            , text " "
            , Button.button
                (Button.init
                    |> Button.primary
                    |> Button.icon (Just Icon.Plus)
                )
                [ text "Create" ]
            ]
        , messageView model.warnMessage Warning
        , taskListView model
        ]


taskListView : Model -> Html Message
taskListView model =
    model.tasks
        |> List.indexedMap
            (\ndx task ->
                li
                    [ onClick (MarkTaskDone ndx)
                    , if Set.member ndx model.tasksDone then
                        style "text-decoration" "line-through"

                      else
                        style "" ""
                    ]
                    [ text task ]
            )
        |> ul []
