#                                    ╔══════════════════════════╗
#                                    ║ Replace Hash with Object ║
#                                    ║ハッシュからオブジェクトへ║
#                                    ╚══════════════════════════╝

class ReplaceHashWithObject
  class Example
    class Before
      new_network = { nodes: [], old_networks: [] }

      new_network[:old_networks] << node.network
      new_network[:nodes] << node

      new_network[:name] = new_network[:old_networks].collect do |network|
        network.name
      end.join(' - ')
    end

    class After
      new_network = NetworkResult.new

      new_network.old_network << node.new_network
      new_network.nodes << node

      new_network.name = new_network.old_networks.collect do |_new_network|
        network.name
      end.join(' - ')
    end
  end

  class Sample
    class Before
      new_network = { nodes: [], old_networks: [] }

      new_network[:old_networks] << node.new_network
      new_network[:nodes] << node

      new_network[:name] = new_network[:old_networks].collect do |network|
        network.name
      end.join(' - ')
    end

    class Refactor
      class Step1
        class NetworkResult
          def [](attribute)
            instance_variable_get "@#{attribute}"
          end

          def []=(attribute, value)
            instance_variable_set("@#{attribute}", value)
          end
        end
      end

      class Step2
        class NetworkResult < Step1::NetworkResult
          #  ╓                                                                                                  ╖
          #  ║           hashで与えられていたものは初期化する必要がある                                         ║
          #  ╙                                                                                                  ╜
          def initialize
            @old_networks = []
            @nodes = []
          end
        end
      end

      class Step3 < Step2
        # new_network = {node: [], old_networks: []}

        new_network = NetworkResult.new
      end

      class Step4 < Step2
        class NetworkResult
          attr_reader :old_networks

          # new_network[:old_networks] << node.network
          new_network.old_networks << node.network
        end
      end
    end
  end
end
