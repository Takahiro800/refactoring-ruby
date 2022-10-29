# frozen_string_literal: true

#                                 ╔═════════════════════════════════╗
#                                 ║ 6.12 Extract Surrounding Method ║
#                                 ║   サンドイッチメソッドの抽出    ║
#                                 ╚═════════════════════════════════╝

class ExtractSurroundingMethod
  class Example
    class Before
      def charge(amount, _credit, _card_number)
        connection = CreditCardServer.connect
        connection.send(amount, credit_card_number)
      rescue IOError => e
        Logger.log "Could not submit order #{@order_number} to the server: #{e}"
        nil
      ensure
        connection.close
      end
    end

    class After
      def charge(amount, credit_card_number)
        connect do |connection|
          connection.send(amount, credit_card_number)
        end
      end

      def connect
        connection = CreditCardServer.connect
        yield connection
      rescue IOError => e
        Logger.log "Clould not submit order #{@order_number} to the server: #{e}"
        nil
      ensure
        connection.close
      end
    end
  end

  class Sample
    class Person
      attr_reader :mother, :children, :name

      def initialize(name, date_of_birth, date_of_death = nil, mother = nil)
        @name = name
        @mother = mother
        @date_of_birth = date_of_birth
        @date_of_death = date_of_death

        @children = []
        @mother&.add_child(self)
      end

      def add_child(child)
        @children << child
      end

      #  ╓                                                                                                  ╖
      #  ║       リファクタリング対象の二つのメソッド                                                       ║
      #  ╙                                                                                                  ╜
      def number_of_living_descendants
        children.inject(0) do |count, child|
          count += 1 if child.alive?
          count + child.number_of_living_descendants
        end
      end

      def number_of_descendants_named(name)
        children.inject(0) do |count, child|
          count += 1 if child.name == name
          count + child.number_of_descendants_named(name)
        end
      end

      private

      def alive?
        @date_of_death.nil?
      end
    end

    class Refactor < Person
      #  ╓                                                                                                  ╖
      #  ║       まず、重複しているコードの中のひとつで「メソッドの抽出」を行う                             ║
      #  ║       共通動作に基づく名前を与える(count_descendants_matching)                                   ║
      #  ╙                                                                                                  ╜
      class Step1
        def number_of_descendants_named(name)
          count_descendants_matching(name)
        end

        protected

        def count_descendants_matching(name)
          children.inject(0) do |count, child|
            count += 1 if child.name == name
            count + child.child.count_descendants_matching(name)
          end
        end
      end

      #  ╓                                                                                                  ╖
      #  ║       呼び出し元メソッドがサンドイッチメソッドにブロックを渡すようにして、                       ║
      #  ║       そのブロックに名前が基準に会うかどうかをチェックするロジックを組み込む。                   ║
      #  ║       チェックできるようにするためには、呼び出し元にchildをyieldにする                           ║
      #  ╙                                                                                                  ╜
      class Step2 < Step1
        def number_of_descendants_named(_name)
          count_descendants_matching { |descendant| descendant.name == name }
        end

        def count_descendants_matching
          children.inject(0) do |count, child|
            count += 1 if yield child
            count + child.count_descendants_matching(&block)
          end
        end
      end

      #  ╓                                                                                                  ╖
      #  ║       新しいサンドイッチメソッドを使うように書き換える                                           ║
      #  ╙                                                                                                  ╜
      class Step3 < Step2
        def number_of_living_descendants
          count_descendants_matching(&:alive?)
        end
      end
    end
  end
end
