port module Main exposing (..)
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
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as D



-- MAIN
--   mianはElmでは特別な値で、画面に何を表示するかを記述します
--   type Program flags model msg = Program
main : Program () Model Msg
main =
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }




-- MODEL
--   modelはアプリケーションが持つデータを表現している、initは初期状態の定義
--   draft = 入力された文字列
--   messages = websocketに送信されたメッセージ一覧
type alias Model =
    { draft : String
    , messages : List String
    }

init : () -> ( Model, Cmd msg )
init _ =
  ({ draft = "", messages = [] }, Cmd.none)



-- PORTS
--   外部とデータを入出力するための機能
port sendMessage : String -> Cmd msg
port messageReceiver : (String -> msg) -> Sub msg


-- UPDATE
--   HTMLのイベントなどで発生したメッセージを元に、モデルを操作したい内容を記述する場所
--   操作したい内容は Msgというカスタム型を作り、その中で定義するのが慣例
--   update関数はMsgとModelを受け取り、新しいモデルを返す

type Msg
  = DraftChanged String
  | Send
  | Recv String

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    DraftChanged draft ->
      ( { model | draft = draft }, Cmd.none )
    
    Send ->
      ( { model | draft = "" }, sendMessage model.draft )
    
    Recv message ->
      ( { model | messages = model.messages ++ [message] }, Cmd.none )



-- SUBSCRIPTIONS
--   外部からの情報を定期的に待ち受けるという意味
subscriptions : Model -> Sub Msg
subscriptions _ =
    messageReceiver Recv





-- VIEW
--   view関数は画面にModelの内容を表示する関数
--   view関数はModelを受け取り、Html msgを返す
view : Model -> Html Msg
view model =
  div []
      [ h1 [] [ text "Echo Chat"]
      , ul []
           (List.map (\list -> li [] [ text list ]) model.messages )
      , input
          [ type_ "text"
          , placeholder "draft"
          , value model.draft
          , onInput DraftChanged
          , on "keydown" (ifIsEnter Send)
          ]
          []
      , button [ onClick Send ] [ text "Send" ]
      ]


-- Enter入力を検出してデコードする関数
ifIsEnter : msg -> D.Decoder msg
ifIsEnter msg =
  D.field "key" D.string
    |> D.andThen (\key -> if key == "Enter" then D.succeed msg else D.fail "some other key")