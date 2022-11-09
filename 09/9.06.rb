#                          ╔═══════════════════════════════════════════════╗
#                          ║ Replace Nested Conditional with Guard Clauses ║
#                          ║        条件分岐のネストからガード節へ         ║
#                          ╚═══════════════════════════════════════════════╝

class ReplaceNestedConditionalWithGuardClauses
  class Example
    class Before
      #  ╓                                                                                                  ╖
      #  ║ 正常な実行経路がはっきりしないような条件分岐を持っている                                         ║
      #  ╙                                                                                                  ╜
      def pay_amount
        # if @dead
        #   result = dead_amount
        # else
        # if @separated
        #   result = separated_amount
        #   else
        #     if @retired
        #       result = retired_amount
        #       else
        #         result = normal_pay_amount
        #     end
        # end
      end
    end

    class After
      def pay_amount
        return dead_amount if @dead
        return separated_amount if @separated
        return retired_amount if @retired

        normal_pay_amount
      end
    end
  end

  #  ╓                                                                                                  ╖
  #  ║   条件式を逆にする                                                                               ║
  #  ╙                                                                                                  ╜
  class Sample1
    class Before
      def adjuted_capital
        # result = 0.0
        # if @capital > 0.0
        #   if @interest_rate > 0.0 && @duration >0.0
        #   result = (@income / @duration) * ADJ_FACTOR
        #   end
        # end
        # result
      end
    end

    # 逆にしながらリファクタリングを進める
  end
end
