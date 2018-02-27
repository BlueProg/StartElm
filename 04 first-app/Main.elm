module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Debug exposing (..)


type alias Model =
    { calories : Int
    , inputVal : Int
    , error : Maybe String
    }


initModel : Model
initModel =
    { calories = 0, inputVal = 0, error = Nothing }


type Msg
    = AddCalories
    | Clear
    | SetValue String


update : Msg -> Model -> Model
update msg model =
    case msg of
        AddCalories ->
            { model | calories = model.calories + model.inputVal, inputVal = 0 }

        Clear ->
            initModel

        SetValue newVal ->
            case String.toInt newVal of
                Ok val ->
                    Debug.log
                        (toString
                            val
                        )
                        { model | inputVal = val, error = Nothing }

                Err err ->
                    { model | inputVal = 0, error = Just err }


view : Model -> Html Msg
view model =
    div []
        [ h3 []
            [ text ("Calories " ++ (toString model.calories)) ]
        , input
            [ type_ "text"
            , onInput
                SetValue
            , value (toString model.inputVal)
            ]
            []
        , div [] [ text (Maybe.withDefault "" model.error) ]
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
