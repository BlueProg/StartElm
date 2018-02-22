module Main exposing (..)

import Html


(~=) str1 str2 =
    let
        firstLetter1 =
            String.slice 0 1 str1

        firstLetter2 =
            String.slice 0 1 str2
    in
        if firstLetter1 == firstLetter2 then
            True
        else
            False


main =
    "Bonjour"
        ~= "Salut"
        -- Call Infix mode
        |> toString
        |> Html.text
