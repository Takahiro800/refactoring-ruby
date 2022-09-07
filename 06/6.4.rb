class ReplaceTempWithQuery
end

class Sample::Before
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

class Sample::After
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
