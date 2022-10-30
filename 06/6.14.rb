# frozen_string_literal: true

#                                    ╔═══════════════════════════╗
#                                    ║ Introduce Named Parameter ║
#                                    ║    名前付き引数の導入     ║
#                                    ╚═══════════════════════════╝
#  ╓                                                                                                  ╖
#  ║ 呼び出しているメソッドの名前からは使われている                                                   ║
#  ║ 引数の意味が簡単に推測できない。                                                                 ║
#  ║ 引数リストをハッシュに変換し、ハッシュキーを引数の名前として使う                                 ║
#  ╙                                                                                                  ╜
class IntroduceNamedParameter
  class Example
    class Before
      SearchCriteria.new(5, 8, '0201485672')
    end

    class After
      SearchCriteria.new(author_id: 5, plublisher_id: 8, isbn: '0201485672')
    end
  end

  class Sample1 # 全ての引数に名前をつける
    class Before
      class SearchCriteria
        attr_reader :author_id, :plublisher_id, :isbn

        def initialize(author_id, plublisher_id, isbn)
          @author_id = author_id
          @publisher_id = plublisher_id
          @isbn = isbn
        end
      end
    end

    class Refactor
      #  ╓                                                                                                  ╖
      #  ║       まず、コンストラクターにキー / 値ペアを渡すように呼び出し元コードを書き換える              ║
      #  ╙                                                                                                  ╜
      class Step1
        criteria = SearchCriteria.new(
          author_id: 5, plublisher_id: 8, isbn: '0201485672'
        )
      end

      #  ╓                                                                                                  ╖
      #  ║       次に、Hashを受け付けるようにinitializeメソッドを書き換え、                                 ║
      #  ║       Hashからの値を使って、インスタンス変数を初期化する                                         ║
      #  ╙                                                                                                  ╜
      class Step2
        class SearchCritria
          def initialize(params)
            @author_id = params[:author_id]
            @publisher_id = params[:publisher_id]
            @isbn = params[:isbn]
          end
        end
      end

      #  ╓                                                                                                  ╖
      #  ║       呼び出し元コードはこれでかなり綺麗になるが、                                               ║
      #  ║       クラス定義を見てメソッドの必須引数を知りたいと思ったら、                                   ║
      #  ║       メソッド定義をじっくり読んで必須引数を探す必要がある。                                     ║
      #  ║       今回のようにHashのキーと同じ名前のインスタンス変数に                                       ║
      #  ║       ただ代入を行うだけの初期化メソッドがある場合、                                             ║
      #  ║       『クラスアノテーションの導入』を使って初期化メソッドを宣言に書き換える(6.13)               ║
      #  ╙                                                                                                  ╜
    end
  end
end
