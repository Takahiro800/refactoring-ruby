# ---------------------------------------------------------------------------- #
#                         Replace Parameter with Method                        #
#                                   引数からメソッドへ                              #
# ---------------------------------------------------------------------------- #

# ------------------- メソッドが引数として渡される値を他の手段で手に入れられるなら、そうすべき ------------------- #
# ----------------------- 長い引数リストはわかりにくいので、できるだけ短くするべき ----------------------- #
class ReplaceParameterWithMethod
  class Example
    class Before
      base_price = @quantity * @item_price
      level_of_discount = discount_level
      final_price = discounted_price(base_price, level_of_discount)
    end

    class After
      base_price = @quantity * @item_price

      final_price = discounted_price(base_price)
    end
  end

  class Sample
    class Before
      def price
        base_price = @quantity * @item_price

        level_of_discount = 1
        level_of_discount = 2 if @quantity > 100

        discounted_price(base_price, level_of_discount)
      end

      def discounted_price(base_price, level_of_discount)
        return base_price * 0.1 if level_of_discount == 2

        base_price * 0.05
      end
    end
  end

  class MyRefactor
    # -------------------------- level_of_discountを削除する -------------------------- #
    def price
      base_price = @quantity * @item_price

      discounted_price(base_price)
    end

    def discounted_price(base_price)
      return base_price * 0.1 if @quantity > 100

      base_price * 0.05
    end
  end

  class Refactor
    class Step1
      # --------------------------- 値引きレベルの計算を抽出してメソッドにする -------------------------- #
      def price
        base_price = @quantity * @item_price
        level_of_discount = discount_level

        discounted_price(base_price, level_of_discount)
      end

      def discount_level
        return 2 if @quantity > 100

        1
      end

      def discounted_price(base_price, level_of_discount)
        return base_price * 0.1 if level_of_discount == 2

        base_price * 0.05
      end
    end

    class Step2 < Step1
      # ---------------------- 引数の参照箇所をdiscounted_priceに書き換える ---------------------- #
      def discounted_price(base_price, _level_of_discount)
        return base_price * 0.1 if discount_level == 2

        base_price * 0.05
      end
    end

    class Step3 < Step2
      # ----------------------------------- 引数の削除 ---------------------------------- #
      def discounted_price(base_price)
        return base_price * 0.1 if discount_level == 2

        base_price * 0.05
      end
    end

    class Step4 < Step3
      # ---------------------------------- 一時変数の削除 --------------------------------- #
      def price
        base_price = @qutantity * @item_price

        discounted_price(base_price)
      end
    end
  end
end
