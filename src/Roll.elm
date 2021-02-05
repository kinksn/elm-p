module Roll exposing (..)
{-- Elmは初期値を画面に描画することから始まります。そこから以下のループに入ります。

1. ユーザーからの入力を待ちます
2. updateにメッセージを送ります
3. 新しいModelを生成します
4. view関数を呼び出して新しいHTMLを取得します
5. 画面上に新しいHTMLを表示します
繰り返します！


-- アプリ内容：「Roll」ボタンを押すと1-6までの数字がランダムで表示される

- [model]
    - DieFace（サイコロの面を表現）
    - 初期状態は1と「Roll」ボタン


- [update]
    - Roll（乱数を実行する）
    - NewFace（新しいモデルを生成する）
--}

import Browser
import Html exposing (..)
import Html.Events exposing (..)
import Random



-- MAIN mianはElmでは特別な値で、画面に何を表示するかを記述します


main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }



-- MODEL modelはアプリケーションが持つデータを表現している、initは初期状態の定義
type alias Model = { dieFace : Int }

init : () -> ( Model, Cmd Msg )
init _ =
    ( Model 1
    , Cmd.none
    )



-- UPDATE HTMLのイベントなどで発生したメッセージを元に、モデルを操作したい内容を記述する場所
-- 操作したい内容は Msgというカスタム型を作り、その中で定義するのが慣例
-- update関数はMsgとModelを受け取り、新しいモデルを返す

type Msg
    = Roll
    | NewFace Int

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Roll ->
            ( model
            , Random.generate NewFace (Random.int 1 6))
        
        NewFace newFace ->
            ( Model newFace
            , Cmd.none
            )




-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none




-- VIEW view関数は画面にModelの内容を表示する関数
-- view関数はModelを受け取り、Html msgを返す
view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text ( String.fromInt model.dieFace ) ]
        , button [ onClick Roll ] [ text "Roll" ]
        ]