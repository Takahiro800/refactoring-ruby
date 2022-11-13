# ---------------------------------------------------------------------------- #
#                         Separate Query from Modifier                         #
#                           問い合わせと更新の分離                                 #
# ---------------------------------------------------------------------------- #

class SeparateQueryFromModifier
  class Sample
    class Before
      def found_miscreant(people)
        people.each do |person|
          if person == 'Don'
            send_alert
            return 'Don'
          end

          if person == 'John'
            send_alert
            return 'john'
          end
        end
        ''
      end

      def check_security(people)
        found = found_miscreant(people)
        some_later_code(found)
      end
    end

    class Refactor
      # ---------------------------- まず、適切な問い合わせメソッドを作る ---------------------------- #
      class Step1
        def found_person(people)
          people.each do |person|
            return 'Don' if person == 'Don'
            return 'John' if person == 'John'
          end
          ''
        end
      end

      class Step2 < Step1
        def found_miscreant(people)
          people.each do |person|
            if person == 'Don'
              send_alert
              found_person(people)
            end
            if person == 'John'
              send_alert
              found_person(people)
            end
          end
          found_person(person)
        end
      end

      class Step3 < Step2
        # -------------- 全ての呼び出し元メソッドがまず更新メソッド、次に問い合わせメソッドを呼び出すように書き換える -------------- #
        def check_security(people)
          found_miscreant(people)
          found = found_person(people)
          some_later_code(found)
        end
      end

      class Step4 < Step3
        def found_miscreant(people)
          people.each do |person|
            if person == 'Don'
              send_alert
              return
            end
            if person == 'John'
              send_alert
              return
            end
          end
          nil
        end
      end
    end
  end
end
