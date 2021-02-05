module Clock exposing (..)
{-- Elmは初期値を画面に描画することから始まります。そこから以下のループに入ります。

1. ユーザーからの入力を待ちます
2. updateにメッセージを送ります
3. 新しいModelを生成します
4. view関数を呼び出して新しいHTMLを取得します
5. 画面上に新しいHTMLを表示します
繰り返します！


▼作るアプリケーション：現在時刻を1秒ごとに更新する(hh:mm:ss)
- アプリケーションで時間を表現するには「POSIX時間」と「タイムゾーン」が必要
- hh:mm:ss の形式で表示

- [MODEL]
- POSIX時間とタイムゾーンを持たせる
- zone : Time.Zone, time : Time.Posix


- [UPDATE]
- モデルのPOSIX時間とタイムゾーンを更新するためのMsg
- 
--}

import Browser
import Html exposing (..)
import Task
import Time




-- MAIN mianはElmでは特別な値で、画面に何を表示するかを記述します

main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }



-- MODEL modelはアプリケーションが持つデータを表現している、initは初期状態の定義

type alias Model =
  { zone : Time.Zone
  , time : Time.Posix
  }

init : () -> (Model, Cmd Msg)
init _ =
  ( Model Time.utc (Time.millisToPosix 0 )
  , Task.perform AdjustTimeZone Time.here
  )



-- UPDATE HTMLのイベントなどで発生したメッセージを元に、モデルを操作したい内容を記述する場所
-- 操作したい内容は Msgというカスタム型を作り、その中で定義するのが慣例
-- update関数はMsgとModelを受け取り、新しいモデルを返す

type Msg
  = Tick Time.Posix
  | AdjustTimeZone Time.Zone


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Tick newTime ->
      ( { model | time = newTime }, Cmd.none )

    AdjustTimeZone here ->
      ( { model | zone = here }, Cmd.none )




-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions _ =
  Time.every 1000 Tick




-- VIEW view関数は画面にModelの内容を表示する関数
-- view関数はModelを受け取り、Html msgを返す

view : Model -> Html Msg
view model =
  let
    hour = String.fromInt ( Time.toHour model.zone model.time )
    minutes = String.fromInt ( Time.toMinute model.zone model.time )
    second = String.fromInt ( Time.toSecond model.zone model.time )
  in
    h1 [] [ text ( hour ++ "：" ++ minutes ++ "：" ++ second ) ]