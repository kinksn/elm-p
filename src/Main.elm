module Main exposing (..)
{-- Elmは初期値を画面に描画することから始まります。そこから以下のループに入ります。

1. ユーザーからの入力を待ちます
2. updateにメッセージを送ります
3. 新しいModelを生成します
4. view関数を呼び出して新しいHTMLを取得します
5. 画面上に新しいHTMLを表示します
繰り返します！


▼作るアプリケーション： 入力した文字列をそのまま返し、リストに追加していくアプリケーション (\msg -> li [] [ text msg ]) func みたいな


--}

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Url



-- MAIN
--   mianはElmでは特別な値で、画面に何を表示するかを記述します
--   type Program flags model msg = Program
main : Program () Model Msg
main =
  Browser.application
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    , onUrlChange = UrlChanged
    , onUrlRequest = LinkClicked
    }




-- MODEL
--   modelはアプリケーションが持つデータを表現している、initは初期状態の定義
type alias Model =
    { key : Nav.Key
    , url : Url.Url}

init : () -> Url.Url -> Nav.Key -> (Model, Cmd Msg)
init _ url key =
  (Model key url , Cmd.none)


-- UPDATE
--   HTMLのイベントなどで発生したメッセージを元に、モデルを操作したい内容を記述する場所
--   操作したい内容は Msgというカスタム型を作り、その中で定義するのが慣例
--   update関数はMsgとModelを受け取り、新しいモデルを返す

type Msg
  = LinkClicked Browser.UrlRequest
  | UrlChanged Url.Url

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
      LinkClicked urlRequest ->
        case urlRequest of
          Browser.Internal url ->
            ( model, Nav.pushUrl model.key (Url.toString url))
          
          Browser.External href ->
            ( model, Nav.load href)

      UrlChanged url ->
        ( { model | url = url }, Cmd.none )




-- SUBSCRIPTIONS
--   外部からの情報を定期的に待ち受けるという意味
subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none





-- VIEW
--   view関数は画面にModelの内容を表示する関数
--   view関数はModelを受け取り、Html msgを返す
view : Model -> Browser.Document Msg
view model =
  { title = "URL intercepter"
  , body =
      [ text "The CurrentLink Is"
      , b [] [ text (Url.toString model.url)]
      , ul []
          [
            linkContainer "/home"
          , linkContainer "/unko"
          ]
      ]
  }

linkContainer : String -> Html msg
linkContainer path =
  li [] [ a [ href path ] [ text path ] ]