#                                  ╔══════════════════════════════╗
#                                  ║ Lazily Initialized Attribute ║
#                                  ║     属性初期化の遅延実行     ║
#                                  ╚══════════════════════════════╝

class LazilyInitializedAttribute
  #  ╓                                                                                                  ╖
  #  ║   構築時ではなく、アクセス時に初期化する                                                         ║
  #  ╙                                                                                                  ╜
  class Example
    class Before
      class Employee
        def initialize
          @emails = []
        end
      end
    end

    class After
      class Employee
        def emails
          @emails ||= []
        end
      end
    end
  end

  #  ╓                                                                                                  ╖
  #  ║   ||=を使った例                                                                                  ║
  #  ╙                                                                                                  ╜
  class Sample1
    class Before
      class Employee
        attr_reader :emails, :voice_mails

        def initialize
          @emails = []
          @voice_mails = []
        end
      end
    end

    class After
      class Employee
        def emails
          @emails ||= []
        end

        def voice_mails
          @voice_mails ||= []
        end
      end
    end
  end

  #  ╓                                                                                                  ╖
  #  ║   instance_variable_defined? を使った例                                                          ║
  #  ║   Sample1はnilやfalseの場合は使えない。                                                          ║
  #  ╙                                                                                                  ╜
  class Sample2
    class Before
      class Employee
        def initialize
          @assistant = Employee.find_by_boss_id(id)
        end
      end
    end

    class After
      class Employee
        def assistant
          @assistant = Employee.find_by_boss_id(id) unless instance_variable_defined?(:@assistant)
          @assistant
        end
      end
    end
  end
end
