#                                        ╔══════════════════╗
#                                        ║    Move Field    ║
#                                        ║ フィールドの移動 ║
#                                        ╚══════════════════╝

#  ╓                                                                                                  ╖
#  ║ フィールドを持っている情報を使うメソッドが同じクラスのものよりも別のクラスのものの方が           ║
#  ║ 多くなってくると、『フィールドの移動』を検討する.                                                ║
#  ║ メソッドも移す場合もあるが、それはインターフェイスによって決める。                               ║
#  ║ 別の理由は『クラスの抽出(Extract Class)』.                                                       ║
#  ║   その場合は、まずフィールドを移してからメソッドを移す                                           ║
#  ╙                                                                                                  ╜

class MoveField
  class Example
    class Before
      class Account
        def interest_for_amount_days(amount, days)
          @interest_rate * amount * days / 365
        end
      end
    end

    #  ╓                                                                                                  ╖
    #  ║     AccountTypeに @interest_rateを移したい。                                                     ║
    #  ║     interest_for_amount_days以外にも、このフィールドを参照するメソッドは複数ある                 ║
    #  ╙                                                                                                  ╜
    class Refactor
      まずは、AccountTypeに属性を作る。
      次に、AccountTypeを使うようにメソッドを書き換える。
      class Step1
        class AccountType
          attr_reader :interest_rate
        end

        class Account
          def interest_for_amount_days(amount, days)
            @account_type.interest_rate * amount * days / 365
          end
        end
      end
    end
  end

  class Sample1
    class Before
      class Account
        attr_accessor :interest_rate

        def interest_for_amount_days(amount, days)
          interest_rate * amount * days / 365
        end
      end
    end

    class Refactor
      #  ╓                                                                                                  ╖
      #  ║       移動させるフィールドをを使っているメソッドがいくつもある場合は、                           ║
      #  ║       まず『自己カプセルフィールド』を適用する                                                   ║
      #  ╙                                                                                                  ╜
      class Step1
        class ACcount
          def interest_for_amount_days(amount, days)
            interest_rate * amount * days / 365
          end

          def interest_rate
            @account_type.interest_rate
          end
        end
      end
    end
  end
end
