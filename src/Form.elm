{-
テキスト入力でメモできるアプリ
・テキストの入力
・メモの表示
以上をモデルに持たせたい
-}



module Form exposing (main)

import Debug
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)




main : Program () Model Msg
main = 
    Browser.sandbox
        {
            init = init
        ,   update = update
        ,   view = view
        }




-- MODEL

type alias Model =
    {
        input : String
    ,   memos : List String
    }

init : Model
init =
    {
        input = ""
    ,   memos = []
    }




-- UPDATE

type Msg
    = Input String
    | Submit
    | Delete Int

update : Msg -> Model -> Model
update msg model =
    case msg of
        Input input ->
            { model | input = input }

        Submit ->
            { model
                | input = ""
                , memos = model.input :: model.memos
            }
        
        Delete num ->
            {
                model
                    | memos = List.take num model.memos ++ List.drop (num + 1) model.memos
            }




-- VIEW

view : Model -> Html Msg
view model =
    div []
        [ Html.form [ onSubmit Submit ]
            [ input [ value model.input, onInput Input] []
            , button
                [ disabled (String.length model.input < 1) ]
                [ text "Submit" ]
            ]
        ,   ul [] (viewMemo model.memos)
        ]

htmlFunc : Int -> String -> Html Msg
htmlFunc i memo =
    li [ onClick (Delete i) ] [ text memo ]


viewMemo : List String -> List (Html Msg)
viewMemo =
    List.indexedMap htmlFunc