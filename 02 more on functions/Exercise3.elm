module Main exposing (..)

import Html


wordCount =
    String.words >> List.length



-- Composition function


main =
    "Ceci est un test"
        |> wordCount
        |> toString
        |> Html.text
