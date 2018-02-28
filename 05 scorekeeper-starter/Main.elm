module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


type alias Model =
    { players : List Player
    , playerName : String
    , playerId : Maybe Int
    , plays : List Play
    }


type alias Player =
    { playerId : Int
    , playerName : String
    , playerScore : Int
    }


type alias Play =
    { id : Int
    , playerId : Int
    , playerName : String
    , points : Int
    }


initModel : Model
initModel =
    { players = []
    , playerName = ""
    , playerId = Maybe.Nothing
    , plays = []
    }


type Msg
    = Edit Player
    | Score Player Int
    | Input String
    | Save
    | Cancel
    | DeletePlay Play


update : Msg -> Model -> Model
update msg model =
    case msg of
        Input val ->
            Debug.log val
                { model | playerName = val }

        Save ->
            if (String.isEmpty model.playerName) then
                model
            else
                save model

        Cancel ->
            { model | playerName = "", playerId = Nothing }

        Score player points ->
            score model player points

        Edit player ->
            { model | playerName = player.playerName, playerId = Just player.playerId }

        DeletePlay play ->
            deletePlay model play


deletePlay : Model -> Play -> Model
deletePlay model play =
    let
        newListPlays =
            List.filter
                (\p ->
                    if p.id /= play.id then
                        True
                    else
                        False
                )
                model.plays

        updateListPlayers =
            List.map
                (\player ->
                    if player.playerId == play.playerId then
                        { player | playerScore = player.playerScore - 1 * play.points }
                    else
                        player
                )
                model.players
    in
        { model | players = updateListPlayers, plays = newListPlays }


score : Model -> Player -> Int -> Model
score model scorer points =
    let
        newPlayers =
            List.map
                (\player ->
                    if player.playerName == scorer.playerName then
                        { player | playerScore = (player.playerScore + points) }
                    else
                        player
                )
                model.players

        newPlays =
            Play (List.length model.plays) scorer.playerId scorer.playerName points
    in
        { model | players = newPlayers, plays = newPlays :: model.plays }


save : Model -> Model
save model =
    case model.playerId of
        Just playerId ->
            edit model playerId

        Nothing ->
            add model


edit : Model -> Int -> Model
edit model id =
    let
        newPlayers =
            List.map
                (\player ->
                    if player.playerId == id then
                        { player | playerName = model.playerName }
                    else
                        player
                )
                model.players

        playUpdate =
            List.map
                (\play ->
                    if play.playerId == id then
                        { play | playerName = model.playerName }
                    else
                        play
                )
                model.plays
    in
        { model | players = newPlayers, plays = playUpdate, playerName = "", playerId = Nothing }


add : Model -> Model
add model =
    let
        player =
            Player (List.length model.players) model.playerName 0
    in
        { model | players = player :: model.players, playerName = "", playerId = Nothing }


view : Model -> Html Msg
view model =
    div [ class "scoreboard" ]
        [ h1 [] [ text "Score Keeper" ]
        , playerSection model
        , playerForm model
        , playsSection model
        ]


playsSection : Model -> Html Msg
playsSection model =
    div []
        [ playListHeader
        , playList model
        ]


playList : Model -> Html Msg
playList model =
    model.plays
        |> List.map play
        |> ul []


play : Play -> Html Msg
play play =
    li []
        [ i [ class "remove", onClick (DeletePlay play) ] []
        , div [] [ text play.playerName ]
        , div [] [ text (toString play.points) ]
        ]


playListHeader : Html Msg
playListHeader =
    header []
        [ div [] [ text "Plays" ]
        , div [] [ text "Points" ]
        ]


playerSection : Model -> Html Msg
playerSection model =
    div []
        [ playerListHeader
        , playerList model
        , pointTotal model
        ]


playerListHeader : Html Msg
playerListHeader =
    header []
        [ div [] [ text "Name" ]
        , div [] [ text "Points" ]
        ]


playerList : Model -> Html Msg
playerList model =
    model.players
        |> List.sortBy .playerName
        |> List.map player
        |> ul []


player : Player -> Html Msg
player player =
    li []
        [ i
            [ class "edit"
            , onClick (Edit player)
            ]
            []
        , div [] [ text player.playerName ]
        , button
            [ type_ "button"
            , onClick (Score player 2)
            ]
            [ text "2pts" ]
        , button
            [ type_ "button"
            , onClick (Score player 3)
            ]
            [ text "3pts" ]
        , div [] [ text (toString player.playerScore) ]
        ]


pointTotal : Model -> Html Msg
pointTotal model =
    let
        total =
            List.map .playerScore model.players
                |> List.sum
    in
        footer []
            [ div [] [ text "Total:" ]
            , div [] [ text (toString total) ]
            ]


playerForm : Model -> Html Msg
playerForm model =
    Html.form [ onSubmit Save ]
        [ Html.input
            [ type_ "text"
            , placeholder "Add/Edit Player..."
            , onInput Input
            , value model.playerName
            ]
            []
        , Html.button
            [ type_ "submit"
            ]
            [ text "Save" ]
        , Html.button
            [ type_ "button"
            , onClick Cancel
            ]
            [ text "Cancel" ]
        ]


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = initModel
        , update = update
        , view = view
        }
