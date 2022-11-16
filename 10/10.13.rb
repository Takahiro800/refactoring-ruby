# ---------------------------------------------------------------------------- #
#                       Replace Error Code with Execption                      #
#                                  エラーコードから例外へ                            #
# ---------------------------------------------------------------------------- #

class ReplaceErrorCodeWithException
  class Example
    # ------------------------ メソッドがエラーを示すために特別なコードを返している。 ----------------------- #
    class Before
      def withdraw(amount)
        return -1 if amount > @balance

        @balance -= amount
      end
    end

    # -------------------------------- 代わりに例外を生成する ------------------------------- #
    class After
      def withdraw(amount)
        raise BalanceError if amount > @balance

        @balance -= amount
      end
    end
  end

  # ----------------------- サンプル：呼び出し元が呼び出し前にエラー条件をチェックする ---------------------- #
  class Sample1
    class Before
      if account.withdraw(amount) == -1
        hendle_overdrawn
      else
        do_the_usual_thing
      end
    end

    class Refactor
      class Step1
        def withdraw(amount)
          raise ArgumentError if amount > @balance

          @balance -= amount
        end

        if !account.can_withdraw?(amount)
          handle_overdrawn
        else
          account.withdraw(amount)
        end
      end

      class Step2
        # -------------------------- アサーションを使ってより明確にエラーを知らせる ------------------------- #
        class Account
          include Assertions

          def withdraw(amount)
            assert('amount too large') { amount <= @balance }
          end
        end

        module Assertions
          class AssertionFailedError < StandardError; end

          def assert(message, &condition)
            raise AssertionFailedError, "Assertion Failed: #{message}" unless condition.call
          end
        end
      end
    end
  end

  # ------------------------------ 呼び出し元が例外をキャッチする ----------------------------- #
  class Sample2
    # -------------------------------- まず、適切な例外を作る ------------------------------- #
    class Step1
      class BalnaceError < StandardError; end
    end

    # -------------------------------- 呼び出し元を変更する -------------------------------- #
    class Step2 < Step1
      begin account.withdraw(amount)
            do_the_usual_thing
      rescue BalanceError
        handle_overdrawn
      end

      # ------------------------ 例外を使うようにwithdrawメソッドを書き換える ------------------------ #
      class Step3 < Step2
        def withdraw(amount)
          raise BalanceError if amount > @balance

          @balance -= amount
        end
      end
    end
  end
end
