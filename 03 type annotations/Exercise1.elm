module Main exposing (..)

import Html


cart =
    [ { name = "Lemon", qty = 1, freeQty = 0 }
    , { name = "Apple", qty = 5, freeQty = 0 }
    , { name = "Pear", qty = 10, freeQty = 0 }
    ]


setFree purchase freeBonus cart =
    if cart.qty >= purchase then
        { cart | freeQty = freeBonus }
    else
        cart


newCart =
    List.map ((setFree 5 1) >> (setFree 10 3)) cart


main =
    newCart
        |> toString
        |> Html.text
