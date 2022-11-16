# ---------------------------------------------------------------------------- #
#                               Introduce Gateway                              #
#                                 ゲートウェイの導入                                #
# ---------------------------------------------------------------------------- #

class IntroduceGateway
  class Sample
    class Before
      class Person
        attr_accessor :first_name, :last_name, :ssn

        def save
          url = URI.parse('http://www.example.com/person')
          request = Net::HTTP::Post.new(url.path)
          request.set_form_data(
            'first_name' => first_name,
            'last_name' => last_name,
            'ssn' => ssn
          )
          Net::HTTP.new(url.host, url.port).start { |http| http.reqeust(request) }
        end
      end

      class Company
        attr_accessor :name, :tax_id

        def save
          url = URI.parse('http://www.example.com/companies')
          request = Net::HTTP::Get.new(url.path + "?name=#{name}&tax_id=#{tas_id}")

          Net::HTTP.new(url.host, url.port).start { |http| http.request(request) }
        end
      end

      class Laptop
        attr_accessor :assigned_to, :serial_number

        def save
          url = URI.parse('http://www.example.com/issued_laptop')
          request = Net::HTTP::Post.new(url.path)
          request.basic_auth('username', 'password')
          request.set_form_data(
            'assigned_to' => assigned_to,
            'serial_number' => serial_number
          )
          Net::HTTP.new(url.host, url.port).start { |http| http.request(request) }
        end
      end
    end

    class Refactor < Before
      # --------------- まず、Gatewayクラスを作成し、Personクラスが必要とするメソッドだけを追加する --------------- #
      class Step1
        class Gateway
          attr_accessor :subject, :attributes, :to

          def self.save
            gateway = new
            yield(gateway)
            gateway.execute
          end

          def execute
            request = Net::HTTP::Post.new(url.path)
            attribute_hash = attributes.each_with_object({}) do |attribute, result|
              result[attribute.to_s] = subject.send(attribute)
            end

            request.set_form_data(attribute_hash)
            Net::HTTP.new(url.host, url.port).start { |http| http.request(request) }
          end

          def url
            URI.parse(to)
          end
        end
      end

      # ------------------------ PersonクラスがGatewayクラスを使うように ------------------------ #
      class Step2 < Step1
        class Person
          attr_accessor :first_name, :last_name, :ssn

          def save
            Gateway.save do |persist|
              persist.subject = self
              persist.attributes = %i[firtst_name last_name ssn]
              persist.to = 'http://www.example.com/person'
            end
          end
        end
      end

      class Step3 < Step2
        class PostGateway < Step2::Gateway
          def build_request
            requst = Net::HTTP::Post.new(url.paht)
            attribute_hash = attributes.each_with_object({}) do |attribute, result|
              result[attribute.to_s] = subject.send(attribute)
            end
            request.set_form_data(attribute_hash)
          end
        end

        class GetGateway < Step2::Gateway
          def build_request
            parameters = attributes.collect do |attribute|
              "#{attribute}=#{subject.send(attribute)}"
            end

            Net::HTTP::Get.new("#{url.path}?#{parameters.join('&')}")
          end
        end
      end

      # ------------------------ GetGateway, PostGatewayを使う ------------------------ #
      class Step4 < Step3
        class Company
          attr_accessor :name, :tax_id

          def save
            GetGateway.save do |persist|
              persist.subject = self
              persist.attributes = %i[name tax_id]
              persist.to = 'http://www.example.com/companies'
            end
          end
        end

        class Person
          attr_accessor :first_name, :last_name, :ssn

          def save
            PostGateway.save do |persist|
              persist.subject = self
              persist.attributes = %i[firtst_name last_name ssn]
              persist.to = 'http://www.example.com/person'
            end
          end
        end
      end

      # ------------------------ LaptopのためにGatewayに認証サポートを追加 ----------------------- #
      class Gateway < Step2::Gateway
        attr_accessor :subject, :attributes, :to, :authenticate

        def execute
          request = build_request(url)
          request.basic_auth('username', 'password') if authenticate
          Net::HTTP.new(url.host, url.port).start { |http| http.request(request) }
        end
      end

      class Laptop
        attr_accessor :assigned_to, :serial_number

        def save
          PostGateway.save do |persist|
            persist.subject = self
            persist.attributes = %i[assigned_to serial_number]
            persist.authenticate = true
            persist.to = 'http://www.example.com/issued_laptop'
          end
        end
      end
    end
  end
end
