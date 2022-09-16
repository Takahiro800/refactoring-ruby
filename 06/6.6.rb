# 6.6 説明用変数の導入
class IntroduceExplainingVariable
end

# Before < Sample
if platform.upcase.index("MAC") && browser.upcase.index("IF") && initialized? && resize > 0
  #  何かの処理
end

# After < Sample
is_mac_os = platform.upcase.index("MAC")
is_ie_browser = browser.upcase.index("IE")
was_resized = resize > 0

if is_mac_os && is_ie_browser && was_resized
  # 何かの処理
end

class Step1 < IntroduceExplainingVariable
  attr_reader :quantity, :item_price

  def initialize(quantity, item_price)
    @quantity = quantity
    @item_price = item_price
  end

  def price
    # 価格は、基本価格 - 数量割引 +　配送料
    return @quantity * @item_price - [0, @quantity - 500].max * @item_price * 0.05 + [@quantity * @item_price * 0.1, 100.0].min
  end
end

class Step2 < IntroduceExplainingVariable
  attr_reader :quantity, :item_price

  def initialize(quantity, item_price)
    @quantity = quantity
    @item_price = item_price
  end

  def price
    # 価格は、基本価格 - 数量割引 +　配送料
    base_price = @quantity * @item_price
    return base_price -
             [0, @quantity - 500].max * @item_price * 0.05 +
             [@quantity * @item_price * 0.1, 100.0].min
  end
end
