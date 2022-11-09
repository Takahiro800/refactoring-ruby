#                           ╔═════════════════════════════════════════════╗
#                           ║ Consolidate Duplicate Conditional Fragments ║
#                           ║        重複する条件分岐の断片の統合         ║
#                           ╚═════════════════════════════════════════════╝

class ConsolidateDuplicateConditionalFragments
  # 条件式の全ての分岐に同じコード片が含まれている
  # その部分を式の外に出す
  class Example
    class Before
      if special_deal?
        total = price * 0.95
        send_order # 重複
      else
        total = price * 0.98
        send_order # 重複
      end
    end

    class After
      total = if special_deal?
                price * 0.95
              else
                price * 0.98
              end
      send_order
    end
  end
end
