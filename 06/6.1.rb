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

class SampleNoLocalVariableBefore
  def print_owing
    outstanding = 0.0

    # バナーを出力（print banner）
    puts '**************************'
    puts '******** Customer Owes *******'
    puts '**************************'

    # 勘定計算(caluculate outstainding)
    @orders.each do |order|
      outstanding += order.amount
    end

    # 詳細を表示 (print details)
    puts "name: #{@name}"
    puts "amount: #{outstanding}"
  end
end

class SampleNoLocalVariableAfter
  def print_owing
    outstanding = 0.0

    print_banner

    # 勘定計算(caluculate outstainding)
    @orders.each do |order|
      outstanding += order.amount
    end

    # 詳細を表示 (print details)
    puts "name: #{@name}"
    puts "amount: #{outstanding}"
  end

  def print_banner
    # バナーを出力
    puts '**************************'
    puts '******** Customer Owes *******'
    puts '**************************'
  end
end

class ExtractMethodWithLocalVaribaleBefore
  attr_reader :orders, :name

  def print_owing
    outstanding = 0.0

    print_banner

    # 　勘定を計算(calculate outstanding)
    @orders.each do |order|
      outstanding += order.amount
    end

    # 詳細を表示(print details)
    puts "name: #{@name}"
    puts "amount: #{outstanding}"
  end

  def print_banner
    # バナーを表示
    puts '**************************'
    puts '******** Customer Owes *******'
    puts '**************************'
  end
end

class ExtractMethodWithLocalVaribaleAfter
  attr_reader :orders, :name

  def print_owing
    outstanding = 0.0

    print_banner

    # 　勘定を計算(calculate outstanding)
    @orders.each do |order|
      outstanding += order.amount
    end

    print_details(outstanding)
  end

  def print_banner
    # バナーを表示
    puts '**************************'
    puts '******** Customer Owes *******'
    puts '**************************'
  end

  def print_details(outstanding)
    puts "name: #{@name}"
    puts "amount: #{outstanding}"
  end
end
