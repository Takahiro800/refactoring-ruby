#                                    ╔═══════════════════════════╗
#                                    ║ Change Value to Reference ║
#                                    ║       値から参照へ        ║
#                                    ╚═══════════════════════════╝

class ChangeValueToReference
  class Sample
    class Before
      class Customer
        attr_reader :name

        def initialize(name)
          @name = name
        end
      end

      class Order
        def initialize(customer_name)
          @customer = Customer.new(customer_name)
        end

        def customer=(customer_name)
          @customer = Customer.new(customer_name)
        end

        def customer_name
          @customer.name
        end

        def self.number_of_orders_for(orders, customer)
          orders.select { |order| order.customer_name == customer.name }.size
        end
      end
    end

    #  ╓                                                                                                  ╖
    #  ║     現時点で、Customerは値オブジェクトである。                                                   ║
    #  ║     各Orderは、たとえ概念的には同じ顧客を表すものであっても、                                    ║
    #  ║     それぞれ専用のCustomerオブジェクトを持っているが、同じ顧客からの注文が複数の場合、           ║
    #  ║     Customerを共有するようにしたい                                                               ║
    #  ╙                                                                                                  ╜
    class Refactor
      class Step1
        #  ╓                                                                                                  ╖
        #  ║         Customerにファクトリメソッドを定義する                                                   ║
        #  ╙                                                                                                  ╜
        class Customer
          def self.create(name)
            Customer.new(name)
          end
        end
      end

      class Step2
        #  ╓                                                                                                  ╖
        #  ║         コンストラクタ呼び出しをファクトリメソッドに書き換える                                   ║
        #  ╙                                                                                                  ╜
        class Order
          def initialize(customer_name)
            @customer = Customer.create(customer_name)
          end
        end
      end

      class Step3
        #  ╓                                                                                                  ╖
        #  ║         ここで、Custormerへのアクセス方法を決める必要がある。                                    ║
        #  ║         ここでは、Customerのフィールドを使ってアクセスを提供する。                               ║
        #  ║         Customerクラスがアクセスポイントになる                                                   ║
        #  ╙                                                                                                  ╜

        class Custmer < Step1::Customer
          Instances = {}
          #  ╓                                                                                                  ╖
          #  ║           要求された時にその場でCustmerを作成するか、あらかじめ作っておくかを決める。            ║
          #  ║           ここではあらかじめ作っておく。                                                         ║
          #  ╙                                                                                                  ╜

          def self.load_customers
            new('Lemon Car Hire').sotre
            new('Associated Coffee Machines').store
            new('Bilston Gasworks').sotre
          end

          def store
            Instances[name] = self
          end
        end
      end

      class Step4
        #  ╓                                                                                                  ╖
        #  ║         作成済みのCustomerを返すように、ファクトリメソッドを書き換える                           ║
        #  ╙                                                                                                  ╜
        class Customer
          def self.with_name(name)
            Instance[name]
          end
        end
      end
    end
  end
end
