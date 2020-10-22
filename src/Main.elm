module Main exposing (..)

import Browser
import File exposing (File)
import File.Select as Select
import Models.Automata
import Task
import Types.Types as Types
import Utils.Parsing.Automata
import Utils.Utils as Utils
import View.View as View



-- MAIN


main : Program () Types.Model Types.Msg
main =
    Browser.element
        { init = Types.init
        , view = View.view
        , update = update
        , subscriptions = subscriptions
        }



-- UPDATE


update : Types.Msg -> Types.Model -> ( Types.Model, Cmd Types.Msg )
update msg model =
    case msg of
        Types.AFDRequested ->
            ( model, Select.file [ "text/txt" ] Types.AFDSelected )

        Types.AFDSelected file ->
            ( model, Task.perform Types.AFDLoaded (File.toString file) )

        Types.AFDLoaded content ->
            case Utils.Parsing.Automata.parseFiniteDeterministic content of
                Nothing ->
                    ( { model | currentAutomaton = Err "Erro ao ler o autômato" }
                    , Cmd.none
                    )

                Just automaton ->
                    ( { model
                        | currentAutomaton =
                            Ok (Models.Automata.FiniteDeterministic automaton)
                        , afds = automaton :: model.afds
                      }
                    , Cmd.none
                    )



-- SUBSCRIPTIONS


subscriptions : Types.Model -> Sub Types.Msg
subscriptions model =
    Sub.none
