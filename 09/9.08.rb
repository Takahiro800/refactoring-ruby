# ╔══════════════════════════════════════════════════════╗
# ║ Introduce Null Object                                ║
# ║ nullオブジェクトの導入                                    ║
# ╚══════════════════════════════════════════════════════╝

class IntroduceNullObject
  class Example
    class Before
      plan = coustomer ? costomer.plan : BillingPlan.basic
    end
  end

  class Sample
    class Befor
      class Site
        attr_reader :customer
      end

      class Customer
        attr_reader :name, :plan, :history
      end

      class PaymentHistory
        def weeks_delinquent_in_last_year; end
      end

      customer = site.customer
      plan = customer ? customer.plan : BillingPlan.basic

      customer_name = customer ? customer.name : 'occupant'

      weeks_delinquent = customer.nil ? 0 : customer.history.weeks_deliquent_in_last_year
    end

    class Refactor
      class Step1
        class MissingCustomer
          def missing?
            true
          end

          class Customer
            def missing?
              false
            end
          end
        end
      end

      class Step2
        module Nullable
          def missing?
            false
          end
        end

        class Customer
          include Nullable
        end
      end

      class Step3
        class Customer
          def self.new_missing
            MissingCustomer.new
          end
        end

        class Site
          def customer
            @customer || Customer.new_missing
          end
        end

        customer = site.customer
        plan = customer.missing? ? BillingPlan.basic : customer.plan

        customer_name = customer.missing? ? 'ocupant' : customer.name
        weeks_delinquent = customer.missing? ? 0 : customer.history.weeks_delinquent_in_last_year
      end

      class Step4 < Step3
        class NullCustomer
          def name
            'occupant'
          end
        end

        customer_name = customer.name
      end
    end
  end
end
