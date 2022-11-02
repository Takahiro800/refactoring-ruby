#                                 ╔════════════════════════════════╗
#                                 ║ Replace Data Value with Object ║
#                                 ║   データ値からオブジェクトへ   ║
#                                 ╚════════════════════════════════╝

class ReplaceDataValueWithObject
  class Sample
    class Before
      class Order
        attr_accessor :customer

        def initialize(customer)
          @customer = customer
        end

        def number_of_orders_for(orders, customer)
          orders.select { |order| order.customer == customer }.size
        end
      end
    end

    class Refactor
      class Step1
        class Customer
          attr_reader :name

          def initialize(name)
            @name = name
          end
        end
      end

      class Step2
        class Order
          # attr_accessor :customer

          def initialize(_customer)
            @customer = Customer.new
          end
        end

        def customer
          @customer.name
        end

        def customer=(value)
          @customer = Customer.new(value)
        end
      end

      class Step3 < Step2
        class Order
          def customer_name
            @customer.name
          end
        end
      end

      class Step4
        def initialize(customer_name)
          @customer = Customer.new(customer_name)
        end

        def customer=(customer_name)
          @customer = Customer.new(customer_name)
        end
      end
    end
  end
end
