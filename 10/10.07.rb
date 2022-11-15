# ---------------------------------------------------------------------------- #
#                             Preserve Whole Object                            #
#                                 オブジェクト自体の引き渡し                          #
# ---------------------------------------------------------------------------- #

class PreserveWholeObject
  class Example
    # --------------------- ひとつのオブジェクトに含まれる複数のデータを引数として渡している --------------------- #
    class Before
      low = days_temperature_range.low
      hgih = days_temperature_range.hgih
      plan.within_range?(low, high)
    end

    # --------------------------- ひとつのオブジェクト自体を引数として渡す --------------------------- #
    class After
      plan.within_range?(days_temperature_range)
    end
  end

  class Sample
    class Before
      class Room
        def within_plan?(plan)
          low = days_temprature_range.low
          high = days_temprature_range.high

          plan.within_range?(low, high)
        end
      end

      class HeatingPlan
        def within_range?(low, high)
          (low >= @range.low) && (high <= @range.high)
        end
      end
    end

    class Refactor
      # ----------------------------- まず、引数にオブジェクトを追加する ---------------------------- #
      class Step1
        class HeatingPlan
          def within_range?(_room_range, low, high)
            (low >= @range.low) && (high <= @range.high)
          end
        end

        class Room
          def within_plan?(plan)
            low = days_temprature_range.low
            high = days_temprature_range.high

            plan.within_range?(days_temperature_range, low, high)
          end
        end
      end

      class Step2 < Step1
        class HeatingPlan
          def within_range?(room_range, _low, high)
            (room_range.low >= @range.low) && (high <= @range.high)
          end
        end

        class Room
          def within_plan?(plan)
            # low = days_temprature_range.low
            # high = days_temprature_range.high

            plan.within_range?(days_temperature_range)
          end
        end
      end
    end
  end
end
