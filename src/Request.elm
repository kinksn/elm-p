module Request exposing (..)
{-- Elmは初期値を画面に描画することから始まります。そこから以下のループに入ります。

1. ユーザーからの入力を待ちます
2. updateにメッセージを送ります
3. 新しいModelを生成します
4. view関数を呼び出して新しいHTMLを取得します
5. 画面上に新しいHTMLを表示します
繰り返します！


▼作るアプリケーション：「https://elm-lang.org/assets/public-opinion.txt」からテキストデータを取得して画面に表示する
- モデルには取得失敗状態/ローディング状態/取得成功状態を持たせる
- ローディング中は画面に「Loading..」と表示する
- 失敗したら 「Error」と表示する
- テキストはString型
- initでHttp.getリクエストを送る
- Http.get時にCmdを打つ

--}

import Browser
import Html exposing (Html, text, pre)
import Http exposing (..)


errorToString : Http.Error -> String
errorToString error =
    case error of
        BadUrl url ->
            "The URL " ++ url ++ " was invalid"
        Timeout ->
            "Unable to reach the server, try again"
        NetworkError ->
            "Unable to reach the server, check your network connection"
        BadStatus 500 ->
            "The server had a problem, try again later"
        BadStatus 400 ->
            "Verify your information and try again"
        BadStatus _ ->
            "Unknown error"
        BadBody errorMessage ->
            errorMessage




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
    = Failure Http.Error
    | Loading
    | Success String

init : () -> (Model, Cmd Msg)
init _ =
    ( Loading
    , Http.get
        { url = "https://elm-lang.org/assets/public-opinion.txt"
        , expect = Http.expectString GotText
        }
    )




-- UPDATE HTMLのイベントなどで発生したメッセージを元に、モデルを操作したい内容を記述する場所
-- 操作したい内容は Msgというカスタム型を作り、その中で定義するのが慣例
-- update関数はMsgとModelを受け取り、新しいモデルを返す
type Msg
  = GotText (Result Http.Error String) -- GotTextはMsg

update : Msg -> Model -> (Model, Cmd Msg) -- 取得できた場合とできなかった場合のケースを書く
update msg model =
    case msg of
        GotText result ->
            case result of
                Ok txt ->
                    ( Success txt, Cmd.none )
                Err err1 ->
                    ( Failure err1, Cmd.none )





-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none




-- VIEW view関数は画面にModelの内容を表示する関数
-- view関数はModelを受け取り、Html msgを返す
view : Model -> Html Msg
view model =
    case model of
        Loading ->
            text "Loading.."

        Success fullText ->
            pre [] [ text fullText ]
        
        Failure err ->
            text (errorToString err)




-- HTTP
