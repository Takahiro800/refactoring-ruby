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

  class Sample2 # オプション引数だけに名前をつける
    class Before
      class Books
        def self.find(selector, conditions = '', *joins)
          sql = ['SELECT * FROM books']

          joins.each do |join_table|
            sql << "LEFT OUTER JOIN #{join_table} ON"
            sql << "books.#{join_tables.to_s.chap}_id"
            sql << " = #{join_tables}.id"
          end

          sql << "WHERE #{conditions}" unless conditions.empty?
          sql << 'LIMIT 1' if selector == :first

          connection.find(sql.join(' '))
        end
      end
      #  ╓                                                                                                  ╖
      #  ║       このコードのサンプル                                                                       ║
      #  ╙                                                                                                  ╜

      Books.find(:all)
      Books.find(:all, 'title like `%Voodoo Economics`')
      Books.find(:all, 'authors.name == `Jenny James`', :authors)
      Books.find(:first, 'authors.name == `Jenny James`', :authors)

      #  ╓                                                                                                  ╖
      #  ║       joins引数は明確ではない。次の構文の方が、引数の使い方をきちんと伝えられる                  ║
      #  ╙                                                                                                  ╜
      Books.find(:all)
      Books.find(:all, condittions: 'title like `%Voodoo Economics`')
      Books.find(:all, conditions: 'authors.name == `Jenny James`', joins: [:authors])
      Books.find(:first, conditions: 'authors.name == `Jenny James`', joins: [:authors])
    end

    class Refactor
      #  ╓                                                                                                  ╖
      #  ║ 名前をつけたい引数は、すでに引数リストの終わりの方にあるので、移動する必要はない。               ║
      #  ║ conditions, joins引数をHashに取り替え、それに合わせてメソッド定義を書き換える                    ║
      #  ╙                                                                                                  ╜
      class Step1
        class Books
          def self.find(_selector, hash = {})
            hash[:joins] ||= []
            hash[:conditions] ||= ''

            sql = ['SELECT * FROM books']
            hash[:joins].each do |join_table|
              sql << "LEFT OUTER JOIN #{join_table} ON"
              sql << "books.#{join_talbe.to_s.chop}_id"
              sql << "= #{join_table}.id"
            end

            sql << "WHERE #{hash[:conditions]}" unless hash[:conditions].empty?
            sql << 'LIMIT 1' if selector == :first
          end
        end
      end

      #  ╓                                                                                                  ╖
      #  ║       クラス定義を見ると、渡さなければならない引数はメソッド全体を読み通す必要がある             ║
      #  ║       これは「アサーションの導入(Introduce Assertion)」によって改善できる                        ║
      #  ╙                                                                                                  ╜
      class Step2
        module AssertValidKeys
          def assert_valid_keys(*valid_keys)
            unknown_keys = keys - [valid_keys].flatten

            raise(ArgumentError, "Unknown keys(s): #{unknown_keys.join(', ')}") if unknown_keys.any?
          end
        end

        Hash.include AssertValidKeys # module AssertValidKeysをインクルードする

        class Books
          def self.find(selector, hash = {})
            hash.assert_valid_keys :conditions, :joins

            hash[:joins] ||= []
            hash[:conditions] ||= ''

            sql = ['SELECT * FROM books']
            hash[:joins].each do |join_table|
              sql << "LEFT OUTER JOIN #{join_table}"
              sql << "ON books.#{join_table.to_s.chop}_id = #{join_table}.id"
            end

            sql << "WHERE #{hash[:conditions]}" unless hash[:conditions].empty?
            sql << 'LIMIT 1' if selector == :first

            connection.find(sql.join(' '))
          end
        end
      end

      #  ╓                                                                                                  ╖
      #  ║       Step2のメリットは、2つある                                                                 ║
      #  ║       1.メソッドに渡したキーの綴りを間違えた時にすぐにフィードバックを得られること               ║
      #  ║       2.アサーションが必要な引数を読み手に知らせる宣言文的役割を果たす                           ║
      #  ╙                                                                                                  ╜
    end
  end
end
