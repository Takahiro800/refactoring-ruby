#                                          ╔═══════════════╗
#                                          ║ Hide Delegate ║
#                                          ║  委譲の隠蔽   ║
#                                          ╚═══════════════╝

#  ╓                                                                                                  ╖
#  ║ 手順                                                                                             ║
#  ║ 1. 委譲オブジェクトの各メソッドについて、サーバに簡単な委譲メソッドを作る                        ║
#  ║ 2. 委譲オブジェクトではなく、サーバを呼び出すように、クライアントを調整する                      ║
#  ║ 3. 1つのメソッドを調整する度にテストをする                                                       ║
#  ║ 4. 委譲オブジェクトへのアクセスを必要とするクライアントがなくなったら、                          ║
#  ║ サーバの委譲obujけうとアクセッサを取り除く                                                       ║
#  ║ 5. テストする                                                                                    ║
#  ╙                                                                                                  ╜

class HideDelegate
  class Sample
    class Before
      class Person
        attr_accessor :department
      end

      class Department
        attr_reader :manager

        def initialize(manager)
          @manager = manager
        end
      end

      #  ╓                                                                                                  ╖
      #  ║       クライアントがPersonの上司を知りたければ、                                                 ║
      #  ║       まずPersonが所属する部門を知らなければならない                                             ║
      #  ╙                                                                                                  ╜
      manager = john.department.manager
      #  ╓                                                                                                  ╖
      #  ║       これでは、managerの管理はDepartmentクラスが行っているというDepartmentクラスについての知識を║
      #  ║       クライアントに意識させることになる。                                                       ║
      #  ║       クライアントの目からDepartmentクラスの存在を隠せば、この密結合を取り除くことができる。     ║
      #  ║       Personに簡単な委譲メソッドを作ってこれを実現する                                           ║
      #  ╙                                                                                                  ╜
    end

    class Refactor
      class Step1
        class Person < Before::Person
          def manager
            @department.manager
          end
        end
      end

      class Step2
        class Person < Before::Person
          extend Forwardable

          def_delegator :@department, :manger
        end

        #  ╓                                                                                                  ╖
        #  ║         全てのクライアントを書き換える                                                           ║
        #  ╙                                                                                                  ╜
        manager = jogn.manager

        #  ╓                                                                                                  ╖
        #  ║         全てのメソッドとPersonの全てのクライアントについての変更を行ったら、                     ║
        #  ║         PersonのDepartmentゲッターは削除できる                                                   ║
        #  ╙                                                                                                  ╜
      end
    end
  end
end
