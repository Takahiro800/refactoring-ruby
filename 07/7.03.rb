#                                          ╔═══════════════╗
#                                          ║ Extract Class ║
#                                          ║ クラスの抽出  ║
#                                          ╚═══════════════╝

class ExtractClass
  class Sample
    class Before
      class Person
        attr_reader :name
        attr_accessor :office_area_code, :office_number

        def telephone_number
          `(` + @office_area_code + `)` + @office_number
        end
      end
    end

    class Refactor
      #  ╓                                                                                                  ╖
      #  ║     電話番号関連の機能は独自クラスに分割できる                                                   ║
      #  ╙                                                                                                  ╜
      class Step1
        #  ╓                                                                                                  ╖
        #  ║         まず、TeloephoneNumberクラスを用意する                                                   ║
        #  ╙                                                                                                  ╜
        class TeloephoneNumber
        end

        #  ╓                                                                                                  ╖
        #  ║         次に、PersonクラスからTelephoneクラスにリンクを貼る                                      ║
        #  ╙                                                                                                  ╜
        class Person
          attr_reader :name
          attr_accessor :office_area_code, :office_number

          def initialize
            @office_telophone = TeloephoneNumber.new
          end
        end
      end

      #  ╓                                                                                                  ╖
      #  ║       次に、フィールドの１つについて「フィールドの移動」を行う                                   ║
      #  ╙                                                                                                  ╜
      class Step2
        class TelephoneNumber
          attr_accessor :area_code
        end

        class Person
          def telephone_number
            `(` + office_area_code + `)` + @office_number
          end

          def office_area_code
            @office_telephone.area_code
          end

          def office_area_code=(arg)
            @office_telephone.area_code = arg
          end
        end
      end

      #  ╓                                                                                                  ╖
      #  ║       さらに他のフィールドを移し、telephone_numberについて「メソッドの移動」を行う               ║
      #  ╙                                                                                                  ╜
      class Step3
        class Person
          attr_reader :name, :office_telephone

          def initialize
            @office_telephone = TelephoneNumber.new
          end

          def telephone_number
            @office_telephone.telephone_number
          end
        end

        class TelephoneNumber
          attr_accessor :area_code, :number

          def telephone_number
            `(` + office_area_code + `)` + @office_number
          end
        end
      end

      #  ╓                                                                                                  ╖
      #  ║       クライアントに対してどの程度新クラスを公開するかを決める                                   ║
      #  ║       インターフェイスとして                                                                     ║
      #  ║       委譲メソッドを用意すれば完全に隠せるが、公開しても良い                                     ║
      #  ╙                                                                                                  ╜
      class Step4
        #  ╓                                                                                                  ╖
        #  ║         新クラスを公開することにした場合、エイリアシングの危険を考慮する。                       ║
        #  ║         次にような選択肢が考えられる                                                             ║
        #  ║         -　任意のオブジェクトが電話番号の任意の部分を書き換えることを受けれる。                  ║
        #  ║         これは、TelephoneNumberを参照オブジェクトにするということ。『値から参照へ』を検討。      ║
        #  ║         PersonがTelephoneNumberへのアクセスポイントとなる                                        ║
        #  ║         - Personを経由せずに電話番号が書き換えられないようにする。                               ║
        #  ║         この場合、TelephoneNumberをイミュータブルにする必要がある                                ║
        #  ║         - clneを呼び出してクライアントに渡す前にTelephoneNumberにfreezeをかける                  ║
        #  ╙                                                                                                  ╜
      end
    end
  end
end
