module Clock exposing (..)
{-- Elmは初期値を画面に描画することから始まります。そこから以下のループに入ります。

1. ユーザーからの入力を待ちます
2. updateにメッセージを送ります
3. 新しいModelを生成します
4. view関数を呼び出して新しいHTMLを取得します
5. 画面上に新しいHTMLを表示します
繰り返します！


▼作るアプリケーション：ボタンを押すとランダムに猫の画像を表示する

- [MODEL]

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




-- UPDATE HTMLのイベントなどで発生したメッセージを元に、モデルを操作したい内容を記述する場所
-- 操作したい内容は Msgというカスタム型を作り、その中で定義するのが慣例
-- update関数はMsgとModelを受け取り、新しいモデルを返す

-- ボタンを押すとランダムに猫画像を取得する
-- gif画像を取得する




-- SUBSCRIPTIONS





-- VIEW view関数は画面にModelの内容を表示する関数
-- view関数はModelを受け取り、Html msgを返す
