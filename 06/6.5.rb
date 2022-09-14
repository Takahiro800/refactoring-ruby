# 6.5 一時変数からチェインへ(Replace Temp With Chain)
# class ReplaceTempWithChain
# end

# # Before
# mock = Mock.new
# expectation = mock.expects(:a_method_name)
# expectation.with("arguments")
# expactation.returns([1, :array])

# # After
# mock = Mock.new
# mock.expects(:a_method_name).with("arguments").returns([1, :array])

# Sample
class Select
  attr_reader :options

  def options
    @options ||= []
  end

  def add_option(arg)
    options << arg
  end
end

select = Select.new
select.add_option(1999)
select.add_option(2000)
select.add_option(2001)
select.add_option(2002)
p select
#<Select:0x000000010456e078 @options=[1999, 2000, 2001, 2002]>

# Selectのインスタンスを作ってオプションを追加するメソッドを作成する
class Step1 < Select
  attr_reader :options

  def self.with_option(option)
    select = self.new
    select.options << option
    select
  end

  def options
    @options ||= []
  end

  def add_option(arg)
    options << arg
  end
end

# selfを返すようにすることで、チェインできるようにする
class Step2 < Select
  attr_reader :options

  def self.with_option(option)
    select = self.new
    select.options << option
    select
  end

  def options
    @options ||= []
  end

  def add_option(arg)
    options << arg
    # selfを返すようにすることで、チェインできるようにする
    self
  end
end

# 例）
select = Step2.with_option(1999).add_option(2000).add_option(2001).add_option(2002)
p select
#<Step2:0x0000000100f27938 @options=[1999, 2000, 2001, 2002]>

# チェインさせた時にfluentに読めるようにメソッドの名前を変える。
class Step3 < Select
  attr_reader :options

  def self.with_option(option)
    select = self.new
    select.options << option
    select
  end

  def options
    @options ||= []
  end

  # チェインさせた時にfluentに読めるようにメソッドの名前を変える。
  def and(arg)
    options << arg
    # selfを返すようにすることで、チェインできるようにする
    self
  end
end
