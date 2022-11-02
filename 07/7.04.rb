#                                      ╔══════════════════════╗
#                                      ║     Inline Class     ║
#                                      ║ クラスのインライン化 ║
#                                      ╚══════════════════════╝

class InlineClass
  class Sample
    class Before
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
          `(` + area_code + `)` + number
        end
      end
    end

    class Refactor
      #  ╓                                                                                                  ╖
      #  ║       まず、PersonでTelephoneNumberの全ての公開メソッドを宣言する                                ║
      #  ╙                                                                                                  ╜
      class Step1
        class Person
          def area_code
            @office_telephone.area_code
          end

          def area_code=(arg)
            @office_telephone.area_code = arg
          end

          def number
            @office_telephone.number
          end

          def number=(arg)
            @office_telephone.number = arg
          end
        end
      end

      #  ╓                                                                                                  ╖
      #  ║       次にTelephoneNumberのクライアントを探し、Personのインターフェースを使うように書き換える    ║
      #  ╙                                                                                                  ╜
      martin = Person.new
      martin.area_code = '781'
    end
  end
end
