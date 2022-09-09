class ReplaceTempWithQuery
end

class Before
  attr_reader :quantity, :item_price

  def before
    base_price = @quantity * @item_price

    if base_price > 1000
      base_price * 0.95
    else
      base_price * 0.98
    end
  end
end

class After
  attr_reader :quantity, :item_price

  def after
    if base_price > 1000
      base_price * 0.95
    else
      base_price * 0.98
    end
  end

  def base_price
    @quantity * @item_price
  end
end

# 簡単なメソッドから始める
class SampleBefore < ReplaceTempWithQuery
  attr_reader :quantity, :item_price

  def price
    base_price = @quantity * @item_price

    if base_price < 1000
      discount_factor = 0.95
    else
      discount_factor = 0.98
    end

    base_price * discount_factor
  end
end

# まず、代入の右辺を抜き出してメソッドにまとめる
class SampleStep1 < ReplaceTempWithQuery
  attr_reader :quantity, :item_price

  def price
    a_base_price = base_price

    if a_base_price > 1000
      discount_factor = 0.95
    else
      discount_factor = 0.98
    end
    a_base_price * discount_factor
  end

  private

  def base_price
    @quantity * @item_price
  end
end
