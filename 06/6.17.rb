#                                    ╔═══════════════════════════╗
#                                    ║ Dynamic Method Definition ║
#                                    ║     動的メソッド定義      ║
#                                    ╚═══════════════════════════╝

class DynamicMethodDefinition
  class Example1
    class Before
      def failure
        self.state = :failure
      end

      def error
        self.state = :error
      end
    end

    class After
      def_each :failure, :error do |method_name|
        self.stete = method_name
      end
    end
  end

  #  ╓                                                                                                  ╖
  #  ║   「動的メソッド定義」の最大の目的は、                                                           ║
  #  ║   読みやすくメンテナンスしやすい形式でメソッド定義を簡潔に表現すること                           ║
  #  ╙                                                                                                  ╜
  class Sample1 # def_eachを使って類似メソッドを定義する
    class Before
      #  ╓                                                                                                  ╖
      #  ║     次の３つのメソッドは短時にstateへの代入を行っている                                          ║
      #  ╙                                                                                                  ╜
      def failure
        self.state = :failure
      end

      def error
        self.state = :error
      end

      def success
        self.state = :success
      end
    end

    class Refator
      #  ╓                                                                                                  ╖
      #  ║       ループで定義できるが、読みやすいコードではない。                                           ║
      #  ║       対処として、def_eachメソッドを定義する。                                                   ║
      #  ║       ソースコード内で動的定義に気づきやすくなり、していることの意味も理解しやすくなる           ║
      #  ╙                                                                                                  ╜
      class Step1
        %i[failure error success].each do |method|
          define_method(method) do
            self.state = method
          end
        end
      end

      class Step2
        class Class
          def def_each(*method_names, &block)
            method_names.each do |method_name|
              instance_exec(method_name, &block)
            end
          end
        end

        def_each :failure, :error, :success do |method_name|
          self.state = method_name
        end
      end
    end
  end

  class Sample2 # クラスアノテーションに夜インスタンスメソッドの定義
    #  ╓                                                                                                  ╖
    #  ║     より表現力の高いコードにする                                                                       ║
    #  ╙                                                                                                  ╜
    class Before
      def failure
        self.state = :failure
      end

      def error
        self.state = :error
      end

      def success
        self.state = :success
      end
    end

    class Refactor
      def self.states(*args)
        args.each do |arg|
          define_method arg do
            self.state = arg
          end
        end
      end

      states :failure, :error, :success
    end
  end

  class Sample3 # 動的に定義されたモジュールをextendしてメソッドを定義する
    #  ╓                                                                                                  ╖
    #  ║     動作するが、手間がかかり、改修も面倒なコード                                                 ║
    #  ╙                                                                                                  ╜
    class Before
      def initialize(post_data)
        @post_data = post_data
      end

      def params
        @post_data[:params]
      end

      def session
        @post_data[:session]
      end
    end

    class Refactor
      #  ╓                                                                                                  ╖
      #  ║       Hashのキーから動的にメソッドを定義できるようにする                                         ║
      #  ║       インスタンスごとに渡すHashのキーも異なる仕様を考える                                       ║
      #  ╙                                                                                                  ╜
      class Step1
        #  ╓                                                                                                  ╖
        #  ║         読みにくいコード                                                                         ║
        #  ╙                                                                                                  ╜
        def initialize(_post_data)
          (class << self; self; end).class_eval do
            post_data.each_pair do |key, _value|
              define_method key.to_sym do
                value
              end
            end
          end
        end
      end

      class Step2
        class Hash
          def to_module
            hash = self
            Module.new do
              # eachのエイリアス [参考](https://rurema.clear-code.com/class:Hash/query:each_pair/)
              hash.each_pair do |key, value|
                define_method key do
                  value
                end
              end
            end
          end
        end

        class PostData
          def initialize(post_data)
            extend post_data.to_module
          end
        end
      end
    end
  end
end
