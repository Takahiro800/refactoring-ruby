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
    puts "**************************"
    puts "******** Customer Owes *******"
    puts "**************************"

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
    puts "**************************"
    puts "******** Customer Owes *******"
    puts "**************************"
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
    puts "**************************"
    puts "******** Customer Owes *******"
    puts "**************************"
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
    puts "**************************"
    puts "******** Customer Owes *******"
    puts "**************************"
  end

  def print_details(outstanding)
    puts "name: #{@name}"
    puts "amount: #{outstanding}"
  end
end

# ローカル変数への再代入
class ExtractMethodReassignmentToLocalVariablesBefore
  def print_owing
    outstanding = 0.0

    print_banner

    # 勘定を計算
    @orders.each do |order|
      outstanding += order.amount
    end

    print_details(outstanding)
  end
end

class ExtractMethodReassignmentToLocalVariablesStep1
  def print_owing
    print_banner
    outstanding = caluculate_outstanding

    print_details(outstanding)
  end

  def calculate_outstandiing
    outstanding = 0.0
    @orders.each do |order|
      outstanding += order.amount
    end

    outstanding
  end
end

# #　抽出したメソッドをテストしてから、injectを使う
class ExtractMethodReassignmentToLocalVariablesStep2
  def print_owing
    print_banner
    outstanding = caluculate_outstanding

    print_details(outstanding)
  end

  def calculate_outstandiing
    @orders.inject(0.0) { |result, order| result + order.amount }
  end
end

# 変数が複雑な操作を受けている場合
class ExtractMethodRessaignmentToLocalVaribalesVersion2::Before
  def print_owing(previous_amount)
    outstanding = previous_amount * 1.2

    print_banner

    # 勘定を計算（ calculate outstanding ）
    @orders.each do |order|
      outstanding += order.amount
    end

    print_details(outstanding)
  end
end

# 抽出後
class ExtractMethodRessaignmentToLocalVaribalesVersion2::After
  def print_owing(previous_amount)
    outstanding = previous_amount * 1.2
    print_banner
    outstanding = caluculate_outstanding(outstanding)
    print_details(outstanding)
  end

  def caluculate_outstanding(initial_value)
    @orders.inject(initial_value) { |result, order| result + order.amount }
  end
end

# 初期値をわかりやすく
class ExtractMethodRessaignmentToLocalVaribalesVersion2::Step2
  def print_owing(previous_amount)
    print_banner
    outstanding = caluculate_outstanding(previous_amount * 1.2)
    print_details(outstanding)
  end

  def caluculate_outstanding(initial_value)
    @orders.inject(initial_value) { |result, order| result + order.amount }
  end
end
