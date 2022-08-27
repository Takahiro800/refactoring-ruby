class Movie
  # movie = Movie.new("The Watchmen", NewReleasePrice.new)
  # movie.price = RegularPrice.new

  REGULAR = 0
  NEW_RELAEASE = 1
  CHILDRENS = 2

  attr_reader :title, :price_code
  attr_writer :price

  def initialize(title, the_price_code)
    @title, = title
    @price_code = the_price_code
  end

  def charge(days_rented)
    @price.charge(days_rented)
  end

  def frequent_renter_points(days_rented)
    (price_code == NEW_RELAEASE && days_rented > 1) ? 2 : 1
  end
end

class RegularPrice
  def charge(days_rented)
    result = 2
    result += (days_rented - 2) * 1.5 if days_rented > 2
    result
  end
end

class NewReleasePrice
  def charge(days_rented)
    days_rented * 3
  end
end

class ChildrensPrice
  def charge(days_rented)
    result = 1.5
    result += (days_rented - 3) * 1.5 if days_rented > 3
    result
  end
end

class Rental
  attr_reader :movie, :days_rented

  def initialize(movie, days_rented)
    @movie = movie
    @days_rented = days_rented
  end

  def charge
    movie.charge(days_rented)
  end

  def frequent_renter_points
    movie.frequent_renter_poinnts(days_rented)
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
    result = "Rental Record for #{@name}\n"
    @rentals.each do |element|
      # このレンタルの料金を表示
      result += "\t" + element.movie.title + "\t" + element.charge.to_s + "\n"
    end

    # フッター行を追加
    result += "Amount owed is #{total_charge}\n"

    result += "You earned #{total_frequent_renter_points} frequent renter points"
    result
  end

  def html_statement
    result = "<h1>Renatals for <em>#{@name}</em></h1><p>\n"
    @rentals.each do |element|
      # このレンタルの料金を表示
      result += "\t" + each.movie.title + ": " + element.charge.to_s + "<br>\n"
    end

    # フッターを追加
    result += "<p>You owe <em>#{total_charge}</em><p>\n"
    result += "On this rental you earned " + "<em>#{total_frequent_reter_points}</em> " + "frequent reter points<p>"
    result
  end

  private

  def total_charge
    @rentals.inject(0) { |sum, rental| sum + rental.charge }
  end

  def total_frequent_renter_points
    @rentals.inject(0) { |sum, rental| sum + rental.frequent_renter_points }
  end
end
