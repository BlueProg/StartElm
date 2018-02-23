module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


type alias Model =
    Int


initModel : Model
initModel =
    0


type Msg
    = AddCalories
    | Clear


update : Msg -> Model -> Model
update msg model =
    case msg of
        AddCalories ->
            model + 1

        Clear ->
            initModel


view : Model -> Html Msg
view model =
    div []
        [ h3 []
            [ text ("Calories " ++ (toString model)) ]
        , input
            [ value (toString model)
            ]
            []
        , button
            [ type_ "button"
            , onClick AddCalories
            ]
            [ text "Add" ]
        , button
            [ type_ "button"
            , onClick Clear
            ]
            [ text "Clear" ]
        ]


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = initModel
        , view = view
        , update = update
        }
