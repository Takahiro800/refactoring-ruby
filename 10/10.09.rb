# ---------------------------------------------------------------------------- #
#                          Introduce Parameter Object                          #
#                                  引数オブジェクトの導入                           #
# ---------------------------------------------------------------------------- #

class IntroduceParameterObject
  class Sample
    class Before
      class Account
        def add_charge(base_price, tax_rate, imported)
          total = base_price + base_price * tax_rate
          total += base_price * 0.1 if imported
          @charges << total
        end

        def total_charge
          @charges.inject(0) { |total, charge| total + charge }
        end
      end

      account = Account.new
      account.add_charge(5, 0.1, true)
      account.add_charge(12, 0.125, false)

      total = account.total_charge
    end

    # --- base_price, tax_rate, importedはまとめて使われることが多いので、Charge(代金)オブジェクトにまとめる --- #
    class Refactor
      class Step1
        # ------------------- イミュータブルにしてある。エイリアシングによるバグを避けるための賢明な選択 ------------------ #
        class Charge
          # attr_accessor :base_price, :tax_rate, :imported

          def initialize(base_price, tax_rate, imported)
            @base_price = base_price
            @tax_rate = tax_rate
            @imported = imported
          end
        end
      end

      class Step2 < Step1
        # -------------------------- まず、引数リストにこのオブジェクトを追加する -------------------------- #
        class Account
          def add_charge(base_price, tax_rate, imported, _charge = nil)
            total = base_price + base_price * tax_rate
            total += base_price * 0.1 if imported
            @charges << total
          end

          def total_charge
            @charges.inject(0) { |total, charge| total + charge }
          end
        end
      end

      class Step3 < Step2
        # ---------------------- 新オブジェクトを使うように、メソッドと呼び出し元を書き換える ---------------------- #
        class Account
          def add_charge(tax_rate, imported, charge = nil)
            total = charge.base_price + charge.base_price * tax_rate
            total += charge.base_price * 0.1 if imported
            @charges << total
          end

          def total_charge
            @charges.inject(0) { |total, charge| total + charge }
          end
        end

        account = Account.new
        account.add_charge(0.1, true, Charge.new(9.0, nil, nil))
        account.add_charge(0.125, true, Charge.new(12.0, nil, nil))

        total = account.total_charge
      end
    end

    class Step4 < Step3
      # --------------------- 新オブジェクトに他のメソッドの振る舞いを移すと、さらに有意義になる -------------------- #
      class Account
        def add_charge(charge)
          @charges << charge
        end

        def total_charge
          @charges.inject(0) { |total_for_account, charge| total_for_account + charge.total }
        end
      end

      class Charge
        def initialize(base_price, tax_rate, imported)
          @base_price = base_price
          @tax_rate = tax_rate
          @imported = imported
        end

        def total
          result = @base_price + @base_price * @tax_rate
          result += @base_price * 0.1 if @imported
          result
        end
      end
    end
  end
end
