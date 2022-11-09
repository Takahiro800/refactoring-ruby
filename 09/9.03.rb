#                               ╔════════════════════════════════════╗
#                               ║ Consolidate Donditional Expression ║
#                               ║            条件式の統合            ║
#                               ╚════════════════════════════════════╝

class ConsolidateConditionalExpression
  class Example
    class Before
      def disability_amount
        return 0 if @seniority < 2
        return 0 if @months_disabled > 12
        return 0 if @is_part_time
        # 傷病手当金を計算
      end
    end

    class After
      def disability_amount
        return 0 if ineligable_for_disability?
        # 傷病手当金を計算
      end
    end
  end

  class Sample1
    class Before
      def disability_amount
        return 0 if @seniority < 2
        return 0 if @months_disabled > 12
        return 0 if @is_part_time
        # 傷病手当金を計算
      end
    end

    class Refactor
      class Step1
        def disability_amount
          return 0 if @seniority < 2 || @months_disabled > 12 || @is_part_time
        end
      end

      class Step2
        def disability_amount
          return 0 if ineligable_for_disability?
        end

        def ineligable_for_disability?
          @seniority < 2 || @months_disabled > 12 || @is_part_time
        end
      end
    end
  end

  def sample2
    # before
    if on_vacation? && (length_of_service > 10)
      puts 'test'
      return 1
    end
    return 1 if on_vacation? && (length_of_service > 10)
  end
end
