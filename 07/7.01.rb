# frozen_string_literal: true

#                                         ╔════════════════╗
#                                         ║  Move Method   ║
#                                         ║ メソッドの移動 ║
#                                         ╚════════════════╝
class MoveMethod
  class Sample
    class Before
      class Account
        def overdraft_charge
          if @account_type.premium?
            result = 10
            result += (@days_overdrawn - 7) * 0.85 if @days_overdrawn > 7
            result
          else
            @days_overdrawn * 1.75
          end
        end

        def bank_charge
          result = 4.5
          result += overdraft_charge if @days_overdrawn.positive?
          result
        end
      end
    end

    class Refactor
      class Step1
        #  ╓                                                                                                  ╖
        #  ║       仕様                                                                                       ║
        #  ║       新しい口座の種類が作られ、overdraft_chargeの計算方法が種類ごとに異なる                     ║
        #  ║       新しく、AccountTypeクラスを作成してoverdraft_chargeを移行したい                            ║
        #  ║       まずは、メソッド全体をコピーして調整する                                                   ║
        #  ╙                                                                                                  ╜
        class AccountType
          def overdraft_charge(days_overdrawn)
            if premium?
              result = 10
              result += (days_overdrawn - 7) * 0.85 if days_overdrawn > 7
            else
              days_overdrawn * 1.75
            end
          end
        end
      end

      #  ╓                                                                                                  ╖
      #  ║       この場合、調整とは、AccountTypeのメソッド、フィールドを使っているところから                ║
      #  ║       @account_typeを取り除き、Accountのメソッド・フィールドで必要なものについて                 ║
      #  ║       以下の４種類の対処を考える                                                                 ║
      #  ║       1.ターゲットクラスにそれらのメソッド、フィールドも移す                                     ║
      #  ║       2.ターゲットクラス内にソースクラスへの参照を作るか、既存の参照を利用する                   ║
      #  ║       3.メソッドへの引数としてソースオブジェクトを渡す                                           ║
      #  ║       4.使われているものがフィールドなら、引数として渡す                                         ║
      #  ╙                                                                                                  ╜
      class Step2
        class Account
          def overdraft_charge
            @account_type.overdraft_charge(@days_overdrawn)
          end
        end
      end

      class Step3 # メソッドはソースクラスから取り除いてしまっても良い
        class Account
          def bank_charge
            result = 4.5
            result += @account_type.overdraft_charge(@days_overdrawn) if @days_overdrawn.positive?

            result
          end
        end
      end
    end
  end
end
