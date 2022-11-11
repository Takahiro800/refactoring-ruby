# ╔══════════════════════════════════════════════════════╗
# ║ IntroduceAssertion                                   ║
# ║ アサーションの導入                                        ║
# ╚══════════════════════════════════════════════════════╝

class IntroduceAssertion
  # ---------------------------------------------------------------------------- #
  #                       プログラムの状態について何らかの条件を前提としているコードがある       #
  #                       アサーションによって、前提条件を明確に表現する                    #
  # ---------------------------------------------------------------------------- #
  アサーションによって、前提条件を明確に表現する
  class Example
    class Before
      def defexpense_limit
        # 支出の上限か担当プロジェクトが必要
        @expense_limit != NULL_EXPENSE ? @expense_limit : @primary_project.member_expense_limit
      end
    end

    class After
      def expense_limit
        assert { (@expense_limit != NULL_EXPENSE) || !@primary_project.nul? }

        @expense_limit != NULL_EXPENSE ? @expense_limit : @primary_project.member_expense_limit
      end
    end
  end
end
