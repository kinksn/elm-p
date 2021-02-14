{-| ページ遷移のデモ

[おおまかな処理の流れ]
1. リンクをクリックすると「LinkClicked」が発火し、Url型レコードの各値が更新される
　- モデルは更新されない
2. コマンドの「Nav.pushUrl」でUrlChangedメッセージが発火する
　- pathが更新されたUrl型の値が渡される
3. モデルのUrlが更新され、view関数が再描画される

[Msg]
- LinkClicked Browser.UrlRequest
　- クリックしたaタグのhrefをUrl型のpathに入れる
　- internalの場合はNav.pushUrl関数を使ってUrlChangedを発火させる
　- externalの場合はNav.load関数を使って新たなページを読み込む（url欄にurlを入れてエンターを入力したときの挙動と同じ）

- UrlChanged Url.Url
　- LinkClickedによって更新された最新のUrl型のurlをmodelに反映させる

[状態]
- modelにはキーとurlを持たせる


-}




-- URL型
type alias Url =
  { protocol : Protocol
  , host : String
  , port_ : Maybe Int
  , path : String
  , query : Maybe String
  , fragment : Maybe String
  }


-- UrlRequest型
type UrlRequest
    = Internal Url.Url
    | External String


-- Key型
--   URLの変更を検出するために必要なもの、modelにはかならず持たせなければいけない
--   modelのkeyはexternalかinternalかを持っている模様
type Key
    = Key




{-| Nav.pushUrlについて
pushUrlは URL を変更しますが、新たに HTML を読み込むことはしません。その代わり、UrlChangedメッセージを引き金にして、
独自に動作を制御できます！これは『ブラウザ履歴』に URL を追加しますので、
『進む』あるいは『戻る』ボタンを押したときもちゃんと動作します。
-}
pushUrl : Key -> String -> Cmd msg
pushUrl =
    Elm.Kernel.Browser.pushUrl


{-| Nav.loadについて
loadは新たな HTML を読み込みます。これは URL バーに URL を入力してエンターキーを押したのと同じです。
Modelに何が起こっていようがすべて投げ捨てて、新たなページ全体が読み込まれます
-}
load : String -> Cmd msg
load =
    Elm.Kernel.Browser.load