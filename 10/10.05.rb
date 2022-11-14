# ---------------------------------------------------------------------------- #
#                              Parameterize Method                             #
#                             メソッドのパラメータ化                                 #
# ---------------------------------------------------------------------------- #

class ParameterizeMethod
  class Sample1
    class Before
      class Employee
        def ten_percent_raise
          @salary *= 1.1
        end

        def five_percent_raise
          @salary *= 1.05
        end
      end
    end

    class Refactor
      class Employee
        def raise(factor)
          @salary *= (1 + factor)
        end
      end
    end
  end

  class Sample2
    class Before
      def base_charge
        result = [last_usage, 100].min * 0.03

        result += ([last_usage, 200].min - 100) * 0.05 if last_usage > 100

        result += ([last_usage, 200].min - 200) * 0.07 if last_usage > 200

        Dollar.new(result)
      end

      def last_usage; end
    end

    class Refactor
      def base_charge
        result = usage_in_range(0..100) * 0.03
        result += usage_in_range(100..200) * 0.05
        result += usage_in_range(200..last_usage) * 0.07

        Dollar.new(result)
      end

      def usage_in_range(range)
        if last_usage > range.begin
          [last_usage, range.end].min - range.begin
        else
          0
        end
      end
    end
  end
end
