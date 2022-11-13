# ---------------------------------------------------------------------------- #
#                                 Rename Method                                #
#                                メソッド名の変更                                   #
# ---------------------------------------------------------------------------- #

class RenameMethod
  class Sample
    class Before
      def telephone_number
        "(#{@officeAreaCode} #{@officeNumber}"
      end
    end

    class Refactor
      #                      まず、新規名のメソッドを別に作り、旧メソッドの中で呼び出すようにする                      #
      class Step1
        class Person
          def telephone_number
            office_telephone_number
          end

          def office_telephone_number
            "(#{@officeAreaCode}) #{@officeNumber}"
          end
        end
      end
    end
  end
end
