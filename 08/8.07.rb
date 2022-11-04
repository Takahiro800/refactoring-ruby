#                       ╔════════════════════════════════════════════════════╗
#                       ║ Change Unidirectional Association to Bidirectional ║
#                       ║           片方向リンクから双方向リンクへ           ║
#                       ╚════════════════════════════════════════════════════╝

class ChangeUnidirectionalAssociationToBidirectional
  class Sample
    class Before
      #  ╓                                                                                                  ╖
      #  ║       Customerを参照するOrderオブジェクトを含むプログラムがある                                  ║
      #  ║       CustomerはOrderに対する参照を持っていない                                                  ║
      #  ╙                                                                                                  ╜
      class Customer
        attr_accessor :customer
      end
    end

    class Refactor
      class Step1
        require 'set'

        def initialize
          @orders = Set.new
        end
      end

      class Step2
        #  ╓                                                                                                  ╖
        #  ║         Orderがリンクを管理するので（README参照                                                  ║
        #  ║         Ordersコレクションに直接アクセスするためのヘルパーメソッドをCustomerに追加する           ║
        #  ╙                                                                                                  ╜
        class Customer
          def friend_orders; end
          # Orderリンクが更新するときにのみ使われる
          @orders
        end
      end

      class Step3
        #  ╓                                                                                                  ╖
        #  ║         attr_accessorをattr_readeに変え、                                                        ║
        #  ║         バックポインタを更新するカスタム属性wirterを追加する                                     ║
        #  ╙                                                                                                  ╜
        class Order
          # attr_accessor :customer

          attr_reader :customer

          def customer=(_value)
            # customer.friend_orders.subtract(self) unless customer.nil?
            customer.friend_orders&.subtract(self)
            @customer = value
            # customer.firend_orders.add(self) unless customer.nil?
            customer.firend_orders&.add(self)
          end
        end
      end
    end
  end
end
