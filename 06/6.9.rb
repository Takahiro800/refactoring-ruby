# frozen_string_literal: true

#                      ╔═══════════════════════════════════╗
#                      ║ Replace Medhot with Method Object ║
#                      ╚═══════════════════════════════════╝
# 1.メソッド独自のオブジェクトに変え、すべてのローカル変数がそのオブジェクトのインスタンス変数になるようにする
#  - こうすれば、メソッドを分解して、同じオブジェクトの別のメソッドにすることができる
#

#                                   ╔════════╗
#                                   ║ Reason ║
#                                   ╚════════╝
# 前提として、大きなメソッドはできるだけ小さいメソッドに分解する方がコードがずっとわかりやすくなる
# メソッドの分解が難しくなるのは、ローカル変数のため。
# 『Replace Temp with Query』を使えば、少しはまともになるが、それでもなかなか分解できないこともある

class ReplaceMEthodWithMethodObject
  class Example
    class Order
      def price
        primary_base_price = 0
        secondary_base_price = 0
        tertiary_base_price = 0
      end
    end
  end

  class Sample
    class Amount
      def gamma(input_val, quantity, year_to_date)
        important_value1 = (input_val * quantity) + delta
        important_value2 = (input_val * year_to_date) + 100

        important_value2 -= 20 if (year_to_date - important_value1) > 100

        important_value3 = important_value2 * 7

        important_value3 - 2 * important_value1
      end
    end

    #  ╓                                                          ╖
    #  ║     1.新しいメソッドをメソッドオブジェクトに書き換える   ║
    #  ╙                                                          ╜
    class Gamma
      attr_reader :account,
                  :input_val,
                  :quantity,
                  :year_to_date,
                  :important_value1, # ここはメソッドのローカル変数
                  :important_value2, # ここはメソッドのローカル変数
                  :important_value3 # ここはメソッドのローカル変数

      #  ╓                                                          ╖
      #  ║       2.コンストラクタを追加する                         ║
      #  ╙                                                          ╜
      def initialize(account, input_val_arg, quantity_arg, year_to_date_arg)
        @account = account
        @input_val = input_val_arg
        @quantity = quantity_arg
        @year_to_date = year_to_date_arg
      end
    end

    class After < Gamma
      def compute
        @important_value1 = (input_val * quantity) + @account.delta
        @important_value2 = (input_val * year_to_date) + 100

        # Extract Method
        ## @important_value2 -= 20 if (year_to_date - important_value1) > 100
        important_thing

        @important_value3 = important_value2 * 7

        @important_value3 - 2 * important_value1
      end

      def important_thing
        @important_value2 -= 20 if (year_to_date - important_value1) > 100
      end

      #  ╓                                                                                 ╖
      #  ║    3.古いメソッドはメソッドオブジェクトに処理を委ねる(委譲する)ように書き換える ║
      #  ╙                                                                                 ╜
      def gamma(input_val, quantity, year_to_date)
        Gamma.new(self, input_val, quantity, year_to_date).compute
      end
    end
  end
end
