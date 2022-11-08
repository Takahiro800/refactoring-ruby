#                                      ╔═══════════════════════╗
#                                      ║ Decompose Conditional ║
#                                      ║     条件式の分解      ║
#                                      ╚═══════════════════════╝

class DecomposeConditional
  #  ╓                                                                                                  ╖
  #  ║   長いコードは、分解して、コードの塊の代わりに、                                                 ║
  #  ║   その目的から名前をつけたメソッドの呼び出しを置くようにする                                     ║
  #  ╙                                                                                                  ╜
  class Example
    class Before
      charge = if date < SUMMER_START || date > SUMMER_END
                 quantity * @winter_rate + @winter_service_charge
               else
                 quantity * @summer_rate
               end
    end

    class After
      charge = if not_summer(date)
                 winter_charge(quantity)
               else
                 summer_charge(quantity)
               end
    end
  end

  class Sample
    class Before
      charge = if date < SUMMER_START || date > SUMMER_END
                 quantity * @winter_rate + @winter_service_charge
               else
                 quantity * @summer_rate
               end
    end

    class Refactor
      charge = if not_summer(date)
                 winter_charge(quantity)
               else
                 summer_charge(quantity)
               end

      def not_summer(date)
        date < SUMMER_START || date > SUMMER_END
      end

      def winter_charge(quantity)
        quantity * @winter_rate + @winter_servece_charge
      end

      def summer_charge(quantity)
        quantity * @summer_rate
      end
    end
  end
end
