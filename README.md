# refactoring-ruby
リファクタリングRubyの学習用リポジトリ

- ソフトウェア開発は素晴らしいものを作りたいという思いと一連の価値観というフィルタを通してなされる小さな判断と行動の連続である。

# 未理解の箇所
## コードと解説文で言っていることが理解できなかった。レベルが離れすぎていると思ったので飛ばした
-[ ] 6.18
-[ ] 6.19
-[ ] 6.20


# 1章
1. 機能を追加しやすい構造になっていないプログラムに機能を追加しなければならなくなったら、まずプログラムをリファクタリングして作業をしやすくしてから追加すること
## 1.2 リファクタリングの第一歩
- リファクタリングをするときの最初の一歩は、そのコードのためにしっかりとしたテストセットを作ること

1. リファクタリングを始める前に、しっかりとしたテストスイートを用意する。テストは自己診断テストでないといけない。

- 長ったらしいメソッドを見かけると、小さな部品に分解できないかを考える
- コードの部品は小さい方が、さまざまな面で管理しやすくなる

## 1.3 メソッドの分解・再配置
1. 新メソッドにスコープが限られる変数、つまりローコアる変数と引数になるべきものを元のコードから探す
2. コード内で変更されるか、変更されないかを確認する
   1. 変更されない変数は引数として渡せる
   2. 変更される変数は慎重に扱う
      1. ひとつだけなら戻り値として返せる

#### Tip
リファクタリングでは、プログラムを少しずつ変更すること。そうすれば、間違えてもすぐにバグを見つけられる.
```
#### Tip
コンピュータが理解できるコードなら誰でも書ける。優れたプログラマが書くのは、人間が理解できるコード
```

## 1.4 金額計算ルーチンの移動
- インスタンスメソッドをよく見て、所属しているクラスの情報を使っていなければ所属クラスの移行を検討する
  - 基本的にメソッドは使っているデータを持つオブジェクトに割り当てるべき
    - Move Method

移行の方法
1. 引数を取り除く
2. メソッド名の変更
3. 移動後のメソッドが動くかテストする
   1. 元のメソッドの中身は、新メソッドに処理を委ねるコードに置き換える
```ruby
class A
	def hoge
		# 移行してきたコードの処理内容
	end
end

class B
	def origin_medhot(a: intance_of(A))
		a.hoge
		# こんな感じで最初のテストは元のメソッドの中で移行の確認をする
	end
end
```
4. 古いメソッドを参照している箇所を全て新しいメソッドを参照するように置き換える

## 1.6 一時変数の削除

# 第６章　メソッドの構成方法
## 6.11 ループからコレクションクロージャメソッドへ
## 6.12 サンドイッチメソッドの抽出
### 理由
ユニークなコードがメソッドの中央にある場合、Rubyのブロックを使えばうまく処理できる
### 手順
1. 重複部分に対して「メソッドの抽出」を行う
2. テストする
3. サンドイッチメソッドにブロックを渡すようにお呼び出し元のコードを書き換える。そして、サンドイッチメソッドに含まれているユニークなロジックをブロックにコピーする。
4. サンドイッチメソッドに残っていたユニークなロジックを消して、代わりにyeildキーワードを追加する。
5. サンドイッチメソッド内にあって、ブロックに移した部分で必要になる変数を津恋止めて、yieldに対する引数として渡す
6. テストする
7. 新しいサンドイッチメソッドを使える他の部分も書き換える

## 6.13
- `define_method`
[Module#define\_method (Ruby 3.1 リファレンスマニュアル)](https://docs.ruby-lang.org/ja/latest/method/Module/i/define_method.html)
  - インスタンスメソッドを定義する
  - ブロックを与えた場合、定義したメソッドの実行時にブロックがレシーバクラスのインスタンスの上でBasicObject#instance_evalされる
- `instance_variable_set`
[Object#instance\_variable\_set (Ruby 3.1 リファレンスマニュアル)](https://docs.ruby-lang.org/ja/latest/method/Object/i/instance_variable_set.html)
  - オブジェクトのインスタンス変数varに値valueを設定する
  - インスタンス変数が定義されていない場合、新たに定義する
  ```ruby
    obj = Object.new
    p obj.instance_variable_set("@foo", 1) <!-- 1 -->
    p obj.instance_variable_set(:@foo, 2) <!-- 2 -->
    p obj.instance_variable_get(:@foo) <!-- 2 -->
  ```

## 6.17
#### instance_exec
与えられたブロックをレシーバのコンテキストに当てて実行する
- [BasicObject#instance\_exec (Ruby 3.1 リファレンスマニュアル)](https://docs.ruby-lang.org/ja/latest/method/BasicObject/i/instance_exec.html)

# 第7章　オブジェクト間でのメンバの移動
## 7.3
エイリアシングの危険を考慮する
- エイリアシング
  違う名前が同じものを指す現象のこと。プログラムの挙動を非常にわかりにくくする。

## 7.5 委譲の隠蔽
Forwardable をextendして、委譲メソッドを宣言する。

# 第８章
## 8.1 自己カプセル化フィールド
- 自己カプセル化
特定のデータ構造とアルゴリズムなどをまとめたソフトウェア複合体の内側の詳細を外側から隠蔽すること
フィールドとそれを操作するメソッドをまとめたオブジェクトの内部要素への直接アクセスを制限するためのアクセスコンロールを設けている

自己カプセル化（Self-Encupsulation） は、クラスの持つフィールドに対してクラス内部からアクセスする場合もアクセサメソッドを経由して行うパターンです。
[自己カプセル化 | okuzawatsの日記](https://okuzawats.com/blog/self-encapsulation/)
[module Forwardable (Ruby 3.1 リファレンスマニュアル)](https://docs.ruby-lang.org/ja/latest/class/Forwardable.html)

フィールドアクセスに関しては、２つの考え方がある。
1. 変数が直接定義されているクラス内では、自由に変数にアクセスできるようにすべき（直接変数アクセス）
2. 同じクラス内でも、必ずアクセッサを使うべきである（間接変数アクセス）
  メリット・・・サブクラスが情報の取得方法をメソッドでオーバーライドできるため、値が必要になった時に初めて初期化を行う遅延初期化の導入など、データの管理方法に柔軟性が生まれる


## 8.3
オブジェクトを参照とオブジェクトと値オブジェクトに分類すると、役に立つことが多い
参照オブジェクトは顧客や口座などで、個々のオブジェクトは実世界の１つのオブジェクトを表している。
オブジェクトが等しいかどうかは、オブジェクトが同一かどうかによって判断する
値オブジェクトは日付や金額などで、データ値によって定義される。コピーがあっても構わない。２つのオブジェクトが等しいかどうかを見分ける必要があるので `eql?`メソッドが必要

違いは明確ではない。切り替えることもある。

## 8.7 片方向リンクから双方向リンクへ
### 疑問
- バックポインタとは？
- リンクを管理するとは？

### リンクを管理させる方のクラスを決める
- 両方のオブジェクトが参照オブジェクトで、関係が1対多なr、1個の参照を持つ方がリンクを管理する（例：１つのCustomerが多数のOrderを持つならOrderがリンクを管理する）
- 片方のオブジェクトがもう片方のメンバなら、メンバを抱え込んでいる方のクラスがリンクを管理する
  - メンバとは？
- 両方のオブジェクトが参照オブジェクトで、多対多なら、どちらでも良い

# 10章
## 10.12 コンストラクタからファクトリメソッドへ
TODO
- [ ] デザインパターン『ファクトリメソッド』について学習する →　デザインパターン学習する

