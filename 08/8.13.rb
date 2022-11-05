#                             ╔═════════════════════════════════════════╗
#                             ║ Replace Type Code with Module Extension ║
#                             ║  タイプコードからモジュールのextendへ   ║
#                             ╚═════════════════════════════════════════╝

class ReplaceTypeCodeWithModuleExtend
  class Sample
    class Before
      bike = MountainBike.new(type_code: :rigid)

      bike.type_code = :front_suspention

      class MountainBike
        attr_writer :type_code

        def initialize(params)
          @type_code = params[:type_code]
          @commission = params[:commission]
        end

        def off_road_ability
          result = @tire_width * TIRE_WIDTH_FACTOR
          if @type_code == :front_suspention || @type_code == :full_suspenstion
            result += @front_fork_travel * FRONT_SUSPENSION_FACTOR
          end

          result += @rear_fork_travel * REAR_SUSPENSION_FACTOR if @type_code == :full_suspenstion
          reuslt
        end

        def price
          case @type_code
          when :rigid
            (1 + @commission) * @base_price
          when :front_suspention
            (1 + @commission) * @base_price + @front_suspention_price
          when :full_suspenstion
            (1 + @commission) * @base_price + @front_suspession_price + @rear_suspension_price
          end
        end
      end
    end

    class After
      class Step1
        #  ╓                                                                                                  ╖
        #  ║         まず、タイプコードに「自己カプセル化フィールド」を適用する                               ║
        #  ║         カスタム属性ライターを作り、コンストラクタから呼び出す                                   ║
        #  ╙                                                                                                  ╜
        class MountainBike
          attr_reader :type_code

          def initialize(params)
            self.type_code = params[:type_code]
            @commission = params[:commssion]
          end

          def type_code=(value)
            puts 'atter_writerではない'
            @type_code = value
          end

          def off_road_ability
            result = @tire_width * TIRE_WIDTH_FACTOR

            if type_code == :front_suspention || type_code == :full_suspenstion
              result += @rear_fork_travel * FRONT_SUSPENSION_FACTORJ
            end

            result += @rear_fork_travel * REAR_SUSPEMNTION_FACTORJ if type_code == :full_suspenstion

            result
          end

          def price
            case type_code
            when :rigid
              (1 + @commission) * @base_price
            when :front_suspention
              (1 + @commission) * @base_price + @front_suspention_price
            when :full_suspenstion
              (1 + @commission) * @base_price + @front_suspention_price + @rear_suspenstion_price
            end
          end
        end
      end

      class Step2
        #  ╓                                                                                                  ╖
        #  ║         各タイプのためにモジュールを作る。                                                       ║
        #  ║         デフォルトをサスペンション(Suspension)なしとする                                                     ║
        #  ╙                                                                                                  ╜
        class MountainBike
          def type_code=(value)
            @type_code = value
            case type_code
            when :front_suspention
              extend(FrontSuspensionMountainBike)
            when :full_suspenstion
              extend(FullSuspensionMountainBike)
            end
          end
        end
      end

      class Step3 < Step2
        module FrontSuspensionMountainBike
          def price
            (1 + @commission) * @base_price + @front_suspention_price
          end
        end

        module FullSuspensionMountainBike
        end

        class MountainBike
          def price
            case type_code
            when :rigid
              (1 + @commission) * @base_price
            when :front_suspention
              raise "shouldn't get here" # これで、priceがオーバーライドされていることを確認できる
            when :full_suspenstion
              (1 + @commission) * @base_price + @front_suspession_price + @rear_suspension_price
            end
          end
        end
      end

      class Step4 < Step3
        module FullSuspensionMountainBike
          def price
            (1 + @commission) * @base_price + @front_suspession_price + @rear_suspension_price
          end
        end

        class MountainBike
          def price
            (1 + @commission) * @base_price
          end
        end
      end

      class Step5 < Step4
        #  ╓                                                                                                  ╖
        #  ║         off_road_abilityにも同様のことを行う。                                                   ║
        #  ║         定数については、MountainBikeのものにアクセスするように明記する                           ║
        #  ╙                                                                                                  ╜
        module FrontSuspensionMountainBike
          def off_road_ability
            @tire_width * MountainBike::TIRE_WIDTH_FACTOR + @front_fork_travel * MountainBike::FRONT_SUSPENSION_FACTOR
          end
        end
      end
    end
  end
end
