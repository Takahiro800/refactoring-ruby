# メソッドの抽出
# ex)
class Before
  def print_owing(amount)
    print_banner
    puts "name: #{@name}"
    puts "amount: #{amount}"
  end
end

class After
  def print_owing(amount)
    print_banner
    print_details(amount)
  end

  def print_details(amount)
    puts "name: #{@name}"
    puts "amount: #{amount}"
  end
end
