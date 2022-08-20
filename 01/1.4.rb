class Movie
  REGULAR = 0
  NEW_RELAEASE = 1
  CHILDRENS = 2

  attr_reader :title
  attr_accessor :price_code

  def initialize(title, price_code)
    @title, @price_code = title, price_code
  end
end

class Rental
  attr_reader :movie, :days_rented

  def initialize(movie, days_rented)
    @movie, @days_rented = movie, days_rented
  end

  def charge
    result = 0

    # 各行の金額を計算
    case rental.movie.price_code
    when Movie::REGULAR
      result += 2
      result += (rental.days_rented - 2) * 1.5 if rental.days_rented > 2
    when Movie::NEW_RELAEASE
      result += rental.days_rented * 3
    when Movie::CHILDRENS
      result += 1.5
      result += (rental.days_rented - 3) * 1.5 if rental.days_rented > 3
    end
    result
  end
end

class Customer
  attr_reader :name

  def initialize(name)
    @name = name
    @rentals = []
  end

  def add_rental(arg)
    @rentals << arg
  end

  # レシートを作成する
  def statement
    total_amount, frequent_renter_points = 0, 0
    result = "Rental Record for #{@name}\n"
    @rentals.each do |element|
      this_amount = element.charge

      frequent_renter_points = frequent_renter_points(element)

      # # レンタルポイントを加算
      # frequent_renter_points += 1

      # # 新作2日間レンタルでボーナス点を加算
      # frequent_renter_points += 1 if element.movie.price_code == Movie::NEW_RELAEASE && element.days_rented > 1

      # このレンタルの料金を表示
      result += "\t" + element.movie.title + "\t" + this_amount.to_s + "\n"
      total_amount += this_amount
    end

    # フッター行を追加
    result += "Amount owed is #{total_amount}\n"
    result += "You earned #{frequent_renter_points} frequent renter points"
    result
  end

  def frequent_renter_points(element)
    (movie.price_code == Movie::NEW_RELAEASE && element.days_rented > 1) ? 2 : 1
  end
end
