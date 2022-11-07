#                                  ╔══════════════════════════════╗
#                                  ║ Replace Subclass with Fields ║
#                                  ║  サブクラスからフィールドへ  ║
#                                  ╚══════════════════════════════╝

class ReplaceSubclassWithFields
  class Sample
    class Before
      class Person
      end

      class Femail < Person
        def femail?
          true
        end

        def code
          'F'
        end
      end

      class Male < Person
        def femail?
          false
        end

        def code
          'M'
        end
      end
    end

    class Refactor
      class Step1
        class Person
          def self.create_female
            Female.new
          end

          def self.create_male
            Male.new
          end
        end

        # bree = Female.new
        bree = Person.create_female
      end

      class Step2
        #  ╓                                                                                                  ╖
        #  ║         スーパークラスにinitializeメソッドを追加し、                                             ║
        #  ║         個々の定数のためにインスタンス変数を割り当てる                                           ║
        #  ╙                                                                                                  ╜
        class Person
          def initialize(female, code)
            @female = female
            @code = code
          end
        end
      end

      class Step3
        #  ╓                                                                                                  ╖
        #  ║         そして、新しいコンストラクタを呼び出すコンストラクタを追加する                           ║
        #  ╙                                                                                                  ╜
        class Female
          def initialize
            super(true, 'F')
          end
        end

        class Male
          def initialize
            super(false, 'M')
          end
        end
      end

      class Step4 < Step3
        class Person
          def female?
            @female
          end
        end
      end

      class Step5 < Step4
        class Person
          def self.create_female
            Person.new(true, 'M')
          end
        end
      end
    end
  end
end
