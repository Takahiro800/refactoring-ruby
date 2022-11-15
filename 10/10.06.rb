# ---------------------------------------------------------------------------- #
#                    Replace Parameter with Explicit Methods                   #
#                                 引数から別々のメソッドへ                            #
# ---------------------------------------------------------------------------- #

class ReplaceParameterWithExplicitMethods
  class Example
    class Before
      def set_value(name, value)
        if name == 'height'
          @height = value
        elsif name == 'width'
          @width == value
        else
          raise 'Should never reach here'
        end
      end
    end

    class After
      def height=(value)
        p 'heightをセット'
        @height = value
      end

      def width=(value)
        p 'widthをセット'
        @width = value
      end
    end
  end

  class Sample
    class Before
      # ---------------------------- Employeeのサブクラスを作りたい --------------------------- #
      ENGINEER = 0
      SALESPERSON = 1
      MANAGER = 2

      def self.create(type)
        case type
        when ENGINEER
          Engineer.new
        when SALESPERSON
          Salesperson.new
        when MANAGER
          Manager.new
        else
          raise ArgumentError, 'Incorrect type code value'
        end
      end
    end

    # -------------------- 個別のサブクラスを作ることは考えづらい,明示的に別々のメソッドを作る -------------------- #
    class Refactor
      class Step1
        def self.create_engineer
          Engineer.new
        end

        def self.create_salesperson
          Salesperson.new
        end

        def self.create_manager
          Manager.new
        end
      end

      class Step2 < Step1
        def self.create(type)
          case type
          when ENGINEER
            Employee.create_engineer
          when SALESPERSON
            Salesperson.new
          when MANAGER
            Manager.new
          else
            raise ArgumentError, 'Incorrect type code value'
          end
        end
      end

      class Step3 < Step2
        def self.create(type)
          case type
          when ENGINEER
            Employee.create_engineer
          when SALESPERSON
            Employee.create_salesperson
          when MANAGER
            Employee.create_manager
          else
            raise ArgumentError, 'Incorrect type code value'
          end
        end

        # kent = Employee.create(Employee::ENGINEER)
        kent = Employee.create_engineer
      end
    end
  end
end
