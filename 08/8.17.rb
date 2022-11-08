#                                  ╔═══════════════════════════════╗
#                                  ║ Eagerly Initialized Attribute ║
#                                  ║     属性初期化の先行実行      ║
#                                  ╚═══════════════════════════════╝

class EagerlyInitializedAttribute
  class Example
    class Before
      class Employee
        def emails
          @emails ||= []
        end
      end
    end

    class After
      class Employee
        def initialize
          @emails = []
        end
      end
    end
  end
end
