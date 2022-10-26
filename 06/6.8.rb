# frozen_string_literal: true

class RemoveAssignmentsToParameters
  class Example::Before
    def discount(input_val, _quantity, _year_to_date)
      input_val -= 2 if input_val > 50
    end
  end

  class Example::After
    def discount(input_val, _quantity, _year_to_date)
      result = input_val
      result -= 2 if input_val > 50
    end
  end

  class Sample
    def discount(input_val, quantity, year_to_date)
      input_val -= 2 if input_val > 50
      input_val -= 1 if quantity > 100
      input_val -= 4 if year_to_date > 10_000
      input_val
    end
  end

  class Refactor
    #  ╓                                                          ╖
    #  ║     引数を一時変数に置き換える                           ║
    #  ╙                                                          ╜
    def step1(input_val, quantity, year_to_date)
      result = input_val
      result -= 2 if input_val > 50
      result -= 1 if quantity > 100
      result -= 4 if year_to_date > 10_000
      result
    end
  end

  class Ledger
    attr_reader :balance

    def initialize_clone(balance)
      @balance = balance
    end

    def add(arg)
      @balance += arg
    end
  end

  class Product
    def self.add_price_by_updating(ledger, price)
      ledger.add(price)
      puts "ledger in add_price_by_updating: #{ledger.balance}"
    end

    def self.add_price_by_replacing(ledger, price)
      ledger = Ledger.new(ledger.balance + price)
      puts "ledger in add_price_by_replacing: #{ledger.balance}"
    end
  end

  l1 = Ledger.new(0)
  Product.add_price_by_updating(l1, 5)
  # これは５になるはず
  puts "l1 after add_price_by_updating: #{l1.balance}"

  l2 = Ledger.new(0)
  Product.add_price_by_replacing(l2, 5)
  # これは0になるはず
  puts "l1 after add_price_by_updating: #{l2.balance}"
end
