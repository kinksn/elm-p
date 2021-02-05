module Test exposing (..)
{-- Elmは初期値を画面に描画することから始まります。そこから以下のループに入ります。

1. ユーザーからの入力を待ちます
2. updateにメッセージを送ります
3. 新しいModelを生成します
4. view関数を呼び出して新しいHTMLを取得します
5. 画面上に新しいHTMLを表示します
繰り返します！


▼作るアプリケーション：ボタンを押すとランダムに猫の画像を表示する
- Http.getリクエストでgiphyのAPIを叩く
- 帰ってきたJsonからURLを取得する
- 取得したURLをimgのsrcにぶちこむ
{
  "data": {
    "type": "gif",
    "id": "l2JhxfHWMBWuDMIpi",
    "title": "cat love GIF by The Secret Life Of Pets",
    "image_url": "https://media1.giphy.com/media/l2JhxfHWMBWuDMIpi/giphy.gif",
    "caption": "",
    ...
  },
  "meta": {
    "status": 200,
    "msg": "OK",
    "response_id": "5b105e44316d3571456c18b3"
  }
}

- [MODEL]
    - Loading
    - Failue
    - Success String
--}

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (Decoder, field, string)



-- MAIN mianはElmでは特別な値で、画面に何を表示するかを記述します


main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }



-- MODEL modelはアプリケーションが持つデータを表現している、initは初期状態の定義
type Model
    = Loading
    | Failure
    | Success String

init : () -> (Model, Cmd Msg)
init model =
    ( Loading
    , getRandamCatImage
    )



-- UPDATE HTMLのイベントなどで発生したメッセージを元に、モデルを操作したい内容を記述する場所
-- 操作したい内容は Msgというカスタム型を作り、その中で定義するのが慣例
-- update関数はMsgとModelを受け取り、新しいモデルを返す

-- ボタンを押すとランダムに猫画像を取得する
-- gif画像を取得する
type Msg
    = MoreGet
    | GotGif (Result Http.Error String)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        MoreGet ->
            ( Loading, getRandamCatImage )
        
        GotGif result ->
            case result of
                Ok url ->
                    ( Success url, Cmd.none )
                
                Err _ ->
                    ( Failure, Cmd.none )




-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none




-- VIEW view関数は画面にModelの内容を表示する関数
-- view関数はModelを受け取り、Html msgを返す
view : Model -> Html Msg
view model =
    div [] 
        [ h2 [] [ text "Get Pipi Image"] 
        , viewGif model
        ]

-- ランダムに猫画像を取得する関数
viewGif : Model -> Html Msg
viewGif model =
    case model of
        Loading ->
            div [] [ text "Please wait.." ]
        
        Failure ->
            div [ style "color" "red" ]
                [ text "I could not load a random cat for some reason. "
                , button [ onClick MoreGet ] [ text "Try Again" ]
                ]
        
        Success url ->
            div []
                [ button [ onClick MoreGet ] [ text "More Get" ]
                , img [ src url ] []
                ]
        
        


-- HTTP
-- ランダムな猫画像をリクエストする関数
getRandamCatImage : Cmd Msg
getRandamCatImage =
    Http.get
        { url = "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=bird"
        , expect = Http.expectJson GotGif gifDecoder
        }



-- data { image_url } をElmのstring型に変換するデコーダー
gifDecoder : Decoder String
gifDecoder =
    field "data" ( field "image_url" string )