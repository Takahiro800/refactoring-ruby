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
