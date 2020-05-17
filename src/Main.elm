module Main exposing (main)

import Browser
import Set exposing (Set)
import Html exposing (Html, div, h3, form, input, ul, li, text)
import Html.Attributes exposing (style, value)
import Html.Events exposing (onInput, onSubmit, onClick)

type alias Model =
  { tasks : List String
  , taskDraft : String
  , tasksDone : Set Int
  }

type Message =
  CreateTask |
  ChangeTaskDraft String |
  MarkTaskDone Int

main =
  Browser.sandbox { init = init, update = update, view = view }

init : Model
init =
  { tasks = []
  , taskDraft = ""
  , tasksDone = Set.empty
  }

update : Message -> Model -> Model
update msg model =
  case msg of
    CreateTask -> 
      { model | tasks = model.taskDraft::model.tasks, taskDraft = "" }
    ChangeTaskDraft newValue ->
      { model | taskDraft = newValue }
    MarkTaskDone ndx ->
      { model | tasksDone =
        if
          Set.member ndx model.tasksDone
        then
          Set.remove ndx model.tasksDone
        else
          Set.insert ndx model.tasksDone
      }

view : Model -> Html Message
view model =
  div [ style "margin" "0 auto"
      , style "max-width" "768px"
      ]
      [ h3 [] [ text "Task List" ]
      , Html.form [ onSubmit CreateTask ]
          [ input [ value model.taskDraft, onInput ChangeTaskDraft ] []
          , input [ Html.Attributes.type_ "submit", value "Create" ] []
          ]
      , renderTaskList model
      ]

renderTaskList : Model -> Html Message
renderTaskList model =
    model.tasks
      |> List.indexedMap (\ndx task ->
        li [ onClick (MarkTaskDone ndx)
           , if Set.member ndx model.tasksDone then style "text-decoration" "line-through" else style "" "" 
           ]
           [ text task ])
      |> ul []
