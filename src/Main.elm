module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onSubmit)

type Message =
  CreateTask |
  ChangeFieldValue String

main =
  Browser.sandbox { init = init, update = update, view = view }

init =
  { tasks = []
  , fieldValue = ""
  }

update msg model =
  case msg of
    CreateTask -> 
      { model | tasks = model.tasks ++ [ model.fieldValue ], fieldValue = "" }
    ChangeFieldValue newValue ->
      { model | fieldValue = newValue }

view model =
  div [ style "margin" "0 auto"
      , style "max-width" "768px"
      ]
      [ h3 [] [ text "Task List" ]
      , Html.form [ onSubmit CreateTask ]
          [ input [ value model.fieldValue, onInput ChangeFieldValue ] []
          , input [ Html.Attributes.type_ "submit", value "Create" ] []
          ]
      , renderTaskList model.tasks
      ]

renderTaskList : List String -> Html Message
renderTaskList list =
    list
       |> List.map (\item -> li [] [ text item ])
       |> ul []
