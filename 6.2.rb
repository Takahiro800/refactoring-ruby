# メソッドのインライン化
class InlineMethod
  attr_reader :number_of_late_deliveries
end

class Before < InlineMethod
  def get_rationg
    more_than_five_late_deliveries ? 2 : 1
  end

  def mote_than_five_late_deliveries
    @number_of_late_deriveries > 5
  end
end

# メソッドの本体を呼び出し元の本体に組み込み、メソッドを削除する
class After < InlineMethod
  def get_rating
    @number_of_late_deliveries > 5 ? 2 : 1
  end
end
