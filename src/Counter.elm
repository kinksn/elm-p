module Counter exposing (main)

import Browser
import Html exposing (Html, div, text, button)
import Html.Events exposing (onClick)




main : Program () Model Msg
main =
    Browser.sandbox
        {   init = init
        ,   update = update
        ,   view = view
        }




-- MODEL

type alias Model =
    Int

init : Model
init =
    0




-- UPDATE

type Msg = Increment | Decrement | Clear

update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            model + 1
        
        Decrement ->
            model - 1
        
        Clear ->
            init




-- VIEW

view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Decrement ] [ text "-" ] 
        , div [] [ text (String.fromInt model) ] 
        , button [ onClick Increment ] [ text "+" ]
        , button [ onClick Clear ] [ text "reset" ]
        ]