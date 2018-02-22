module Main exposing (..)

import Html


upperCasesLongerName name =
    if String.length name > 10 then
        String.toUpper name
    else
        name


main =
    Html.text (upperCasesLongerName "BlueProg is the best")
