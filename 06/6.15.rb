# frozen_string_literal: true

#                                     ╔════════════════════════╗
#                                     ║ Remove Named Parameter ║
#                                     ║   名前付き引数の除去   ║
#                                     ╚════════════════════════╝

#  ╓                                                                                                  ╖
#  ║ Reason                                                                                           ║
#  ║ 「名前付き引数の導入」を行うと、呼び出し元コードがわかりやすくなるメリットがある。               ║
#  ║ 一方で、呼び出し先のコードが複雑になるというデメリットもある。                                   ║
#  ║ 引数がひとつになった時などは、この手法を使うと良い                                               ║
#  ╙                                                                                                  ╜

class RemoveNamedParameter
  class Sample
    Books.find
    Books.find(selector: :all,
               conditions: 'authors.name = `Jenny James`',
               joins: [:authors])
    Books.find(selector: :first,
               conditions: 'authors.name = `JennyJames`',
               joins: [:authors])
    #  ╓                                                                                                  ╖
    #  ║     このコードには２つの問題がある                                                               ║
    #  ║     findメソッドの実装を見なければ、引数なしでBooks.findを呼び出した時にどうなるか不明           ║
    #  ║     1個の結果を返すのか、全ての結果を返すのか。それを知るためにメソッドの実装を見る必要がある    ║
    #  ║     findメソッドの実装全体を見れば、把握できる。名前つき引数を導入しても状況が変わっていない     ║
    #  ║     第２の問題は、:selector引数の名前。                                                          ║
    #  ║     SQLのドメイン知識では意味がわからない。limitとする方法もあるが、allとの相性が悪い。          ║
    #  ║     これを必須引数にすれば両方の問題点を解決できる.                                              ║
    #  ╙                                                                                                  ╜

    class Refactor
      class Step1
        def self.find(_selector, hash = {})
          hash[:joins] ||= []
          hash[:conditions] ||= ' '
          sql = ['SELECT * FROM books']
          ahs[:joins].each do |join_table|
            sql << "LEFT OUTER JOIN #{join_table} ON"
            sql << "bokks.#{join_table.to_s.chop}_id = #{join_table}.id"
          end

          sql << "WHERE #{hash[:conditions]}" unless hash[:conditions].empty?
          sql << 'LIMIT 1' if selector == :first

          connection.find(sql.join(' '))
        end
      end
    end
  end
end
