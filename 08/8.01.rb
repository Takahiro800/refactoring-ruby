#                                     ╔════════════════════════╗
#                                     ║ Self Encapsulate Field ║
#                                     ║ 自己カプセルフィールド ║
#                                     ╚════════════════════════╝

class SelfEncapsulateField
  class Example
    class Before
      def total
        @base_price * (1 + @tax_rate)
      end
    end

    class After
      #  ╓                                                                                                  ╖
      #  ║       自己カプセル化（Self - Encupsulation）は、                                                 ║
      #  ║       クラスの持つフィールドに対してクラス内部からアクセスする場合も                             ║
      #  ║       アクセサメソッドを経由して行うパターン                                                     ║
      #  ╙                                                                                                  ╜

      attr_reader :base_price, :tax_rate

      def total
        base_price * (1 + tax_rate)
      end
    end
  end

  class Sample
    class Before
      class Item
        def initialize(base_price, tax_rate)
          @base_price = base_price
          @tax_rate = tax_rate
        end

        def raise_base_price_by(percent)
          @base_price *= (1 + percent / 100.0)
        end

        def total
          @base_price * (1 + @tax_rate)
        end
      end
    end

    class Refactor
      #  ╓                                                                                                  ╖
      #  ║       まず、ゲッターとセッターを定義し、それらを使うようにする                                   ║
      #  ╙                                                                                                  ╜
      class Step1
        attr_accessor :base_price, :tax_rate

        def raise_base_price_by(persent)
          self.base_price = base_price * (1 + persent / 100.0)
        end

        def total
          base_price * (1 + tax_rate)
        end
      end

      #  ╓                                                                                                  ╖
      #  ║       自己カプセルを使う時は、コンストラクタでセッターメソッドを使うことに注意                   ║
      #  ║       セッターはオブジェクト作成後の変更用だと考えられることが多く、                             ║
      #  ║       セッターが初期化とは異なる動作を実装している可能性がある。                                 ║
      #  ╙                                                                                                  ╜
      class Step2
        def initialize(base_price, tax_rate)
          setup(base_price, tax_rate)
        end

        def seup(base_price, tax_rate)
          @base_price = base_price
          @tax_rate = tax_rate
        end
      end

      #  ╓                                                                                                  ╖
      #  ║       サブクラスがある場合                                                                       ║
      #  ╙                                                                                                  ╜
      class Step3 < Step2
        attr_reader :import_duty

        def initialize(base_price, tax_rate, import_duty)
          super(base_price, tax_rate)
          @import_duty = import_duty
        end

        def tax_rate
          super + import_duty
        end
      end
    end
  end
end
