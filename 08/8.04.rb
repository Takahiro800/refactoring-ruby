#                                    ╔═══════════════════════════╗
#                                    ║ Change Reference to Value ║
#                                    ║       参照から値へ        ║
#                                    ╚═══════════════════════════╝

class ChangeReferenceToValue
  class Sample
    class Before
      class Currency
        attr_reader :code

        def initialize(code)
          @code = code
        end

        def self.get(_code)
          # レジストリからCurrencyインスタンスを返す
        end

        usd = Currency.get('USD')

        #  ╓                                                                                                  ╖
        #  ║         Currencyクラスがインスタンスのリストを管理しているので、                                 ║
        #  ║         単純にコンストラクタを使うわけには行かない                                               ║
        #  ╙                                                                                                  ╜
        Currency.new('USD') == Currency.new('USD') # false
        Currency.new('USD').eql?(Currency.new('USD')) # false
      end
    end

    class Refactor
      #  ╓                                                                                                  ╖
      #  ║       このオブジェクトがイミュータブルであることを確かめるのが最も重要。                         ║
      #  ║       ミュータブルな値オブジェクトは、厄介なエイリアシングが避けられない。                       ║
      #  ╙                                                                                                  ╜
      class Step1
        class Currency < Before::Currency
          def eql?(other)
            self == (other)
          end

          def ==(other)
            other.equal?(self) ||
              (other.instance_of?(self.class) && other.code == code)
          end

          #  ╓                                                                                                  ╖
          #  ║           eql? と == で動作が異なるのは困るので、処理を委譲している。                            ║
          #  ║           eql? を定義する時はhashも定義する必要がある。                                          ║
          #  ╙                                                                                                  ╜
        end
      end

      class Step2 < Step1
        class Currency
          def hash
            code.hash
          end
        end
      end
    end
  end
end
