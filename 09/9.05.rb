#                                       ╔═════════════════════╗
#                                       ║ Remove Control Flag ║
#                                       ║  制御フラグの除去   ║
#                                       ╚═════════════════════╝

class RemoveControlFlag
  class Sample1
    class Before
      def check_security(people)
        found = false
        people.each do |person|
          next if found

          if person == 'Don'
            send_alert
            found = true
          end

          if person == 'John'
            send_alert
            found = true
          end
        end
      end
    end

    class Refactor
      def check_security(people)
        people.each do |person|
          if person == 'Don'
            send_alert
            break
          end

          if person == 'John'
            send_alert
            break
          end
        end
      end
    end
  end

  class Sample2
    #  ╓                                                                                                  ╖
    #  ║     制御フラグの結果情報を返すreturn                                                             ║
    #  ╙                                                                                                  ╜
    class Before
      def check_security(people)
        found = ''
        people.each do |person|
          next unless found == ''

          if person == 'Don'
            send_alert
            found = 'Don'
          end

          if person == 'John'
            send_alert
            found = 'John'
          end
        end
        some_leter_code(found)
      end
    end

    #  ╓                                                                                                  ╖
    #  ║     foundが２つのことを行っている                                                                ║
    #  ║     制御フラグとして機能すると同時に、結果を知らせている。                                       ║
    #  ║     foundの判定を行うコードを抽出して独自メソッドにまとめる                                      ║
    #  ╙                                                                                                  ╜
    class Refactor
      class Step1
        def check_security(people)
          found = found_miscreant(people)
          some_later_code(found)
        end

        def found_miscreant(people)
          found = ''
          people.each do |person|
            next unless found == ''

            if person == 'Don'
              send_alert
              found = 'Don'
            end

            if person == 'John'
              send_alert
              found = 'John'
            end
          end
          found
        end
      end

      class Step2 < Step1
        # 制御フラグをreturnに書き換えていく

        def found_miscreant(people)
          found = ''
          people.each do |person|
            next unless found == ''

            if person == 'Don'
              send_alert
              return 'Don'
            end

            if person == 'John'
              send_alert
              return 'John'
            end
          end
        end
      end
    end
  end
end
