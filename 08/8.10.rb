#                                     ╔════════════════════════╗
#                                     ║ Encapsulate Collection ║
#                                     ║コレクションのカプセル化║
#                                     ╚════════════════════════╝

#  ╓                                                                                                  ╖
#  ║ メソッドがコレクションを返している時、                                                           ║
#  ║ コピーを返して、add_ / remove_メソッドを用意する                                                 ║
#  ╙                                                                                                  ╜
class EncapsulateCollection
  class Sample
    #  ╓                                                                                                  ╖
    #  ║     Personが、Courseを受講する。Courseは極めて単純にできている                                   ║
    #  ╙                                                                                                  ╜
    class Before
      class Course
        def initialize(name, advanced)
          @name = name
          @advanced = advanced
        end
      end

      class Person
        attr_accessor :courses
      end

      # クライアントのコード例

      kent = Person.new
      courses = []
      courses << Course.new('Smalltalk Programming', false)
      courses << Course.new('Appreciation Single', true)

      kent.courses = courses
      assert_equal(2, kent.courses.size)

      refactoring = Course.new('Refactoring', true)
      kent.courses << refactoring
      kent.courses << Course.new('Brutal Sarcasm', false)
      assert_equal(4, kent.courses.size)

      kent.courses.delete(refactoring)
      assert_equal(3, kent.courses.size)

      # 上級講座（advanced: trueのもの）について知りたい時は以下のようになる
      person.courses.select { |course| course.advanced? }.size
    end

    class After
      class Person < Before::Person
        class Step1
          def initialize
            @courses = []
          end

          def add_course(course)
            @courses << course
          end

          def remove_course(course)
            @courses.delete(course)
          end
        end

        class Step2
          def courses=(_course)
            raise 'Courses should be empty' unless @courses.empty?

            courses.each { |course| add_course(course) }
          end
        end

        class Step3 < Step2
          # メソッド名を適切なものに変更

          def initialize_courses(_courses)
            raise 'Courses should be empty' unless @courses.empty?

            courses.each { |course| add_course(course) }
          end
        end

        class Step4 < Step3
          # カプセル化が壊れるので、クライアントがArrayに直接変更を加えることはさせない
          # 属性ライターを使うなら、取り除き、add_course, remove_courseを使わせる
          class Before
            kent = Person.new
            courses = []
            courses << Course.new('Smalltalk Programming', false)
            courses << Course.new('Appreciation Single', true)

            kent.iniialize_courses(courses)
          end

          class After
            kent = Person.new
            kent.add_course(Course.new('Smalltalk Programming', false))
            kent.add_course(Course.new('Appreciation Single', true))
          end
        end

        class Step5 < Step4
          # 属性リーダーを使っているコードをみていく
          # 変更を加えるメソッドはAfterのように新しい変更メソッドに書き換えていく必要がある
          class Before
            kent.courses << Course.new('Brutal Sarcasm', false)
          end

          class After
            kent.add_course(Course.new('Brutal Sarcasm', false))
          end
        end

        class Step6 < Step5
          #  ╓                                                                                                  ╖
          #  ║           これでコレクションをカプセル化できた。                                                 ║
          #  ║           Personのメソッドを使う以外の方法でコレクションの要素に変更を加えることはできない       ║
          #  ╙                                                                                                  ╜
          def courses
            @courses.dup
          end
        end

        class Step7 < Step6
          #  ╓                                                                                                  ╖
          #  ║           ふるまいのクラスへの移動                                                               ║
          #  ╙                                                                                                  ╜
          class Before
            #  ╓                                                                                                  ╖
            #  ║             Personの情報のみを扱っているので、Personクラスに移行すべき                           ║
            #  ╙                                                                                                  ╜
            class Courses
              number_of_advanced = person.courses.select(&:advanced?).size
            end
          end

          class After
            class Step1
              #  ╓                                                                                                  ╖
              #  ║                 まず、メソッドの抽出                                                             ║
              #  ╙                                                                                                  ╜
              class Courses
                def number_of_advanced_courses
                  person.courses.select(&:advanced?).size
                end
              end
            end

            class Step2
              class Person
                def number_of_advanced_courses
                  @courses.select(&:advanced?).size
                end
              end
            end
          end
        end
      end
    end
  end
end
