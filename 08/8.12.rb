#                               ╔═════════════════════════════════════╗
#                               ║ Replace Type Code with Polymorphism ║
#                               ║ タイプコードからポリモーフィズムへ  ║
#                               ╚═════════════════════════════════════╝

class ReplaceTypeCodeWithPolymorphism
  class Sample
    class Before
      class MountainBike
        def initialize(params)
          params.each { |key, value| instance_variable_set "@#{key}", value }
        end

        def off_road_ability
          result = @tire_width * TIRE_WIDTH_FACTOR

          if @type_code == :front_suspention || @type_code == :full_suspenstion
            result += @rear_fork_travel * FRONT_SUSPENSION_FACTORJ
          end

          result += @rear_fork_travel * REAR_SUSPEMNTION_FACTORJ if @type_code == :full_suspenstion

          result
        end

        def price
          case @type_code
          when :rigid
            (1 + @commission) * @base_price
          when :front_suspention
            (1 + @commission) * @base_price + @front_suspention_price
          when :full_suspenstion
            (1 + @commission) * @base_price + @front_suspention_price + @rear_suspenstion_price
          end
        end
      end

      # このクラスは次のように使う
      bike = MountainBike.new(type_code: :rigid, tire_width: 2.5)
      bike2 = MountainBike.new(type_code: :front_suspention, tire_width: 2, front_fork_trave: 3)
    end

    class After
      class Step1
        # まず、タイプごとにクラスを作る
        # MountainBikeはモジュールに変え、新クラスからインクルードさせる
        class RigidMountainBike
          include MountainBike
        end

        class FrontSuspensMountainBike
          include MountainBike
        end

        class FullSuspenssionMountainBike
          include MountainBike
        end

        module MountainBike
          # class からmoduleへ変更
          # class MountainBike
          def wheel_circumference
            Math::PI * (@wheel_diameter + @tire_diameter)
          end

          def off_road_ability
            result = @tire_width * TIRE_WIDTH_FACTOR

            if @type_code == :front_suspention || @type_code == :full_suspenstion
              result += @front_fork_travel * FRONT_SUSPENTION_FACTOR
            end
            result += @rear_fork_travel * REAR_SUSPENSION_FACTOR if @type_code == :full_suspenstion

            result
          end

          def price
            case @type_code
            when :rigid
              (1 + @commission) * @base_price
            when :front_suspention
              (1 + @commission) * @base_price + @front_suspention_price
            when :full_suspenstion
              (1 + @commission) * @base_price + @front_suspention_price + @rear_suspension_price
            end
          end
        end

        # bike = MountainBike.new(type_code: :front_suspention, tire_width: 2, front_fork_travel: 3)
        bike = FrontSuspensMountainBike.new(type_code: front_suspension, tire_width: 2, front_fork_travel: 3)
      end

      class Step2 < Step1
        #  ╓                                                                                                  ╖
        #  ║         ポリモーフィックに呼び出したいメソッドを1つ取り出して、                                  ║
        #  ║         『条件分岐からポリモーフィズムへ』を適用し、新クラスの１つのために                       ║
        #  ║         オーバーライドする                                                                       ║
        #  ╙                                                                                                  ╜
        class RigidMountainBike
          include MountainBike

          # このメソッドは、RigidMountainBikeのwhen文全体をオーバーライドする
          def price
            (1 + @commission) * @base_price
          end
        end

        module MountainBike
          def price
            case @type_code
            when :rigid
              raise "shouldn't get here"
            when :front_suspention
              (1 + @commission) * @base_price + @front_suspention_price
            when :full_suspenstion
              (1 + @commission) * @base_price + @front_suspention_price + @rear_suspenstion_price
            end
          end
        end
      end

      class Step3 < Step2 # 他のタイプのクラスにも同様の書き換えを行い、MountainBikeのpriceメソッドを取り除く
        class RigidMountainBike
          include MountainBike

          def price
            (1 + @commission) * @base_price
          end
        end

        class FrontSuspensMountainBike
          include MountainBike

          def price
            (1 + @commission) * @base_price + @front_suspention_price
          end
        end

        class FullSuspenssionMountainBike
          include MountainBike

          def price
            (1 + @commission) * @base_price + @front_suspention_price + @rear_suspenstion_price
          end
        end

        module MountainBike
          # def price
          #   case @type_code
          #   when :rigid
          #     raise "shouldn't get here"
          #   when :front_suspention
          #     (1 + @commission) * @base_price + @front_suspention_price
          #   when :full_suspenstion
          #     (1 + @commission) * @base_price + @front_suspention_price + @rear_suspenstion_price
          #   end
          # end
        end
      end

      class Step4 < Step3
        class RigidMountainBike
          include MountainBike

          def price
            (1 + @commission) * @base_price
          end

          def off_road_ability
            @tire_width * TIRE_WIDTH_FACTOR
          end
        end

        class FrontSuspensMountainBike
          include MountainBike

          def price
            (1 + @commission) * @base_price + @front_suspention_price
          end

          def off_road_ability
            @tire_width * TIRE_WIDTH_FACTOR + @front_fork_travel * FRONT_SUSPENSION_FACTOR
          end
        end

        class FullSuspenssionMountainBike
          include MountainBike

          def price
            (1 + @commission) * @base_price + @front_suspention_price + @rear_suspenstion_price
          end

          def off_road_ability
            @tire_width * TIRE_WIDTH_FACTOR + @front_fork_travel * FRONT_SUSPENSION_FACTOR + @rear_fork_travel * REAR_SUSPENSION_FACTOR
          end
        end
      end
    end
  end
end
