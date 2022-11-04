#                                    ╔═══════════════════════════╗
#                                    ║ Replace Array with Object ║
#                                    ║  配列からオブジェクトへ   ║
#                                    ╚═══════════════════════════╝

class ReplaceArrayWithObject
  class Example
    class Before
      row = []
      row[0] = 'Liverpool'
      row[1] = '15'
    end

    class After
      row = Performance.new
      row.name = 'Liverpool'
      row.wins = '15'
    end
  end

  class Smaple
    class Before
      row = []
      row[0] = 'Liverpool'
      row[1] = '15'

      name = row[0]
      wins = row[1].to_i
    end

    class Refactor
      #  ╓                                                                                                  ╖
      #  ║       1.カスタムオブジェクトに帰るために、クラスを作る                                           ║
      #  ║       2.呼び出し元のコードを１つずつ書き換えられるように、                                       ║
      #  ║       Arrayアクセサメソッドを作る                                                                ║
      #  ╙                                                                                                  ╜
      class Step1
        class Performance
          def initialize
            @data = []
          end

          def []=(index, value)
            @data.insert(index, value)
          end

          def [](index)
            @data[index]
          end
        end
      end

      class Step2
        # Arrayを作成しているコードを探し、Performanceオブジェクトを作るように修正
        row = Performance.new
      end

      class Step3
        #  ╓                                                                                                  ╖
        #  ║         クライアントがArrayから呼び出していた一つ一つの属性に対して                              ║
        #  ║         attr_readerを追加していく                                                                ║
        #  ╙                                                                                                  ╜
        class Performance
          attr_reader :name

          name = row.name
          wins = row[1].to_i
        end
      end
    end
  end

  class Sample2
    class Module
      def deprecate(method_name)
        module_eval <<~END, __FILE__, __LINE__ + 1
          alias_method :deprecated_#{method_name}, :#{method_name}
            def #{method_name}(*args, &block)
              $stderr.puts "Warning: calling deprecated method #{self}.#{method_name}. This method will be removed in a future release."
                deprecated_#{method_name}(*args, &block)
            end
        END
      end
    end
  end
end
