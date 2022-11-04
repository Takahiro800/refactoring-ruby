#                           ╔═════════════════════════════════════════════╗
#                           ║ Replace Magic Number with Symbolic Constant ║
#                           ║     マジックナンバーからシンボル定数へ      ║
#                           ╚═════════════════════════════════════════════╝

class ReplaceMagicNumberWithSymbolicConstant
  class Example
    class Before
      # 9.81がマジックナンバー
      def potential_energy(mass, height)
        mass * 9.81 * height
      end
    end

    class After
      GRABITATIONAL_CONSTANT = 9.81

      def potential_energy(mass, height)
        mass * GRABITATIONAL_CONSTANT * height
      end
    end
  end
end
