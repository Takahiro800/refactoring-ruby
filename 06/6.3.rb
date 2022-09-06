# 6.3 一時変数のインライン化
class InlineTemp
end

class Before < InlineTemp
  def base_price_high?
    base_price = an_order.base_price
    return (base_price > 1000)
  end
end

class After < InlineTemp
  def base_price_high?
    return an_order.base_price > 1000
  end
end
