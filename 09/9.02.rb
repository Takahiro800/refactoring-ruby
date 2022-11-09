#                                      ╔══════════════════════╗
#                                      ║ Recompose Conditions ║
#                                      ║  条件分岐の組み替え  ║
#                                      ╚══════════════════════╝

class RecomposeConditions
  class Example
    class Before
      # parameters = params ?  params : []
    end

    class After
      parametes = params || []
    end
  end

  class Sample2
    class Before
      def reward_points
        if days_rented > 2
          2
        else
          1
        end
      end
    end

    class After
      def reward_points
        return 2 if days_rented > 2

        1
      end
    end
  end
end
