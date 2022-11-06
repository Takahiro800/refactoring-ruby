#                             ╔═════════════════════════════════════════╗
#                             ║ Repalce Type Code with State / Strategy ║
#                             ║   タイプコードからState / Strategyへ    ║
#                             ╚═════════════════════════════════════════╝

class ReplaceTypeCodeWithStateStrategy
  class Sample
    class Before
      class MountainBike
        def initialize(params)
          set_state_from_hash(params)
        end

        def add_front_suspension(params)
          @type_code = :front_suspention
          set_state_from_hash(params)
        end

        def add_rear_suspension(_paramas)
          raise "You can't add rear suspension unless you have front suspension" unless @type_code == :front_suspention

          @type_code = :full_suspenstion
          set_state_from_hash(params)
        end

        def off_road_ability
          result = @tire_width * TIRE_WIDTH_FACTOR

          if @type_code == :front_suspention || @type_code == :full_suspenstion
            result += @front_fork_travel * FRONT_SUSPENSION_FACTOR
          end
          if @type_code == :full_suspenstion
            p 'if文を残したい'
            result += @rear_fork_travel * REAA_SUSPENSION_FACTOR
          end

          result
        end

        def price
          case @type_code
          when :rigid
            (1 + @commission) * @base_price
          when :front_suspention
            (1 + @commission) * @base_price + @front_suspension_price
          when :full_suspenstion
            (1 + @commission) * @base_price + @front_suspession_price + @rear_suspension_price
          end
        end

        private

        def set_state_from_hash(hash)
          @base_price = hash[:base_price] if hash.has_key?(:base_price)
          @front_suspension_price = hash[:fornt_suspension_price] if hash.has_key?(:fornt_suspension_price)
          @rear_suspension_price = hash[:rear_suspension_price] if hash.has_key?(:rear_suspension_price)

          @commission = hash[:commission] if hash.has_key?(:commission)
          @tire_width = hash[:tire_width] if hash.has_key?(:tire_width)
          @front_fork_travel = hash[:front_fork_travel] if hash.has_key?(:front_fork_travel)
          @rear_fork_travel = hash[:rear_fork_travel] if hash.has_key?(:rear_fork_travel)

          @type_code = hash[:type_code] if hash.has_key?(:type_code)
        end
      end
    end

    class Refactor
      class Step1
        #  ╓                                                                                                  ╖
        #  ║         自己カプセル化フィールドを適用する                                                       ║
        #  ║         type_codeに対するアクセスをゲッターとセッターだけに制御する                              ║
        #  ║         タイプがアクセスされている時の並行処理が実行しやすくなる                                 ║
        #  ║         リファクタリングのステップを小さく刻むことができるのもメリット                           ║
        #  ╙                                                                                                  ╜
        class MountainBike
          attr_reader :type_code

          def initialize(params)
            set_state_from_hash(params)
          end

          def type_code=(value)
            @type_code = value
            p ''
          end

          def add_front_suspension(params)
            self.type_code = :front_suspention
            set_state_from_hash(params)
          end

          def add_rear_suspension(_paramas)
            raise "You can't add rear suspension unless you have front suspension" unless type_code == :front_suspention

            self.type_code = :full_suspenstion
            set_state_from_hash(params)
          end

          def off_road_ability
            result = @tire_width * TIRE_WIDTH_FACTOR

            if type_code == :front_suspention || type_code == :full_suspenstion
              result += @front_fork_travel * FRONT_SUSPENSION_FACTOR
            end
            if type_code == :full_suspenstion
              p 'if文を残したい'
              result += @rear_fork_travel * REAA_SUSPENSION_FACTOR
            end

            result
          end

          def price
            case type_code
            when :rigid
              (1 + @commission) * @base_price
            when :front_suspention
              (1 + @commission) * @base_price + @front_suspension_price
            when :full_suspenstion
              (1 + @commission) * @base_price + @front_suspession_price + @rear_suspension_price
            end
          end

          private

          def set_state_from_hash(hash)
            @base_price = hash[:base_price] if hash.has_key?(:base_price)
            @front_suspension_price = hash[:fornt_suspension_price] if hash.has_key?(:fornt_suspension_price)
            @rear_suspension_price = hash[:rear_suspension_price] if hash.has_key?(:rear_suspension_price)

            @commission = hash[:commission] if hash.has_key?(:commission)
            @tire_width = hash[:tire_width] if hash.has_key?(:tire_width)
            @front_fork_travel = hash[:front_fork_travel] if hash.has_key?(:front_fork_travel)
            @rear_fork_travel = hash[:rear_fork_travel] if hash.has_key?(:rear_fork_travel)

            self.type_code = hash[:type_code] if hash.has_key?(:type_code)
          end
        end
      end

      class Step2
        #  ╓                                                                                                  ╖
        #  ║         type_codeごとに空クラスを作成する                                                        ║
        #  ╙                                                                                                  ╜

        class RigidMountainBike
        end

        class FrontSuspensionMountainBike
        end

        class FullSuspensionMountainBike
        end

        class MountainBike
          def type_code=(value)
            @type_code = value
            @bike_type = case type_code
                         when :rigid
                           RigidMountainBike.new
                         when :front_suspention
                           FrontSuspensionMountainBike.new
                         when :full_suspenstion
                           FullSuspensionMountainBike.new
                         end
          end
        end
      end

      class Step3 < Step2
        class RigidMountainBike
          def initialize(params)
            @tire_width = params[:tire_width]
          end

          def off_road_ability
            @tire_width * MountainBike::TIRE_WIDTH_FACTOR
          end
        end

        class FrontSuspensionMountainBike
        end

        class FullSuspensionMountainBike
        end

        class MountainBike
          def type_code=(value)
            @type_code = value
            @bike_type = case type_code
                         when :rigid
                           RigidMountainBike.new(tire_width: @tire_width)
                         when :front_suspention
                           FrontSuspensionMountainBike.new
                         when :full_suspenstion
                           FullSuspensionMountainBike.new
                         end
          end

          def off_road_ability
            return @bike_type.off_road_ability if type_code == :rigid

            result = @tire_width * TIRE_WIDTH_FACTOR

            if @type_code == :front_suspention || @type_code == :full_suspenstion
              result += @front_fork_travel * FRONT_SUSPENSION_FACTOR
            end
            if @type_code == :full_suspenstion
              p 'if文を残したい'
              result += @rear_fork_travel * REAA_SUSPENSION_FACTOR
            end

            result
          end
        end
      end

      class Step4 < Step3
        class FrontSuspensionMountainBike
          def initialize(params)
            @tire_width = params[:tire_width]
            @front_fork_travel = params[:front_fork_trave]
          end

          def off_road_ability
            @tire_width * MountainBike::TIRE_WIDTH_FACTOR + @front_fork_travel * MountainBike::FRONT_SUSPENSION_FACTOR
          end
        end

        class FullSuspensionMountainBike
          def initialize(params)
            @tire_width = params[:tire_width]
            @front_fork_travel = params[:front_fork_trave]
            @rear_fork_travel = params[:rear_fork_trave]
          end

          def off_road_ability
            @tire_width * MountainBike::TIRE_WIDTH_FACTOR + @front_fork_travel * MountainBike::FRONT_SUSPENSION_FACTOR + @rear_fork_travel * MountainBike::REAR_SUSPENSION_FACTOR
          end
        end
      end

      class Step5 < Step4
        #  ╓                                                                                                  ╖
        #  ║         Forwardableを使って,off_road_abilityの処理をタイプクラスに委ねる                         ║
        #  ╙                                                                                                  ╜

        class MountainBike
          extend Forwardable
          def_delegators :@bike_type, :off_road_ability

          attr_reader :type_code

          def type_code=(value)
            @type_code = value
            @bike_type = case type_code
                         when :rigid
                           RigidMountainBike.new(tire_width: @tire_width)
                         when :front_suspension
                           FrontSuspensionMountainBike.new(tire_width: @tire_width,
                                                           front_fork_travel: @front_fork_travel)
                         when :full_suspenstion
                           FullSuspensionMountainBike.new(tire_width: @tire_width,
                                                          front_fork_travel: @front_fork_travel,
                                                          rear_fork_travel: @rear_fork_travel)

                         end
          end
        end
      end

      class Step6 < Step5
        #  ╓                                                                                                  ╖
        #  ║         add_front_suspension, add_rear_suspensionは、                                            ║
        #  ║         @bike_typeに新クラスのどれかのインスタンスをセットするように書き換える必要がある         ║
        #  ╙                                                                                                  ╜
        class MountainBike
          def add_front_suspension(params)
            self.type_code = :front_suspension
            @bike_type = FrontSuspensionMountainBike.new({ tire_width: @tire_width }.merge(params))
            set_state_from_hash(params)
          end

          def add_rear_suspension(params)
            raise "You can't add rear suspension unless you have front suspension" unless type_code == :front_suspension

            self.type_code = :full_suspenstion
            @bike_type = FullSuspensionMountainBike.new({
              tire_width: @tire_width,
              front_fork_travel: @front_fork_travel
            }.merge(params))

            set_status_from_hash(params)
          end
        end
      end

      class Step7 < Step6
        #  ╓                                                                                                  ╖
        #  ║         同じことをpriceメソッドに行う。                                                          ║
        #  ║         type_codeを除く仕事に取り掛かる                                                          ║
        #  ╙                                                                                                  ╜

        class MountainBike
          def_delegators :@bike_type, :off_road_ability, :price

          def type_code=(value)
            @type_code = value
            @bike_type = case type_code
                         when :rigid
                           RigidMountainBike.new(
                             tire_width: @tire_width,
                             base_price: @base_price
                           )

                         when :front_suspension
                           FRontSuspentionMountainBike.new(
                             tire_width: @tire_width,
                             front_fork_price: @front_suspension_price,
                             base_price: @base_price,
                             commission: @commission
                           )
                         when :full_suspenstion
                           FullSuspensionMountainBike.new(
                             tire_width: @tire_width,
                             front_fork_price: @front_suspension_price,
                             rear_fork_travel: @rear_fork_travel,
                             base_price: @base_price,
                             commission: @commission
                           )
                         end
          end

          def add_front_suspension(params)
            # self.type_code = :front_suspension
            @bike_type = FrontSuspensionMountainBike.new({
              tire_width: @bike_type.tire_width,
              front_fork_travel: @bike_type.front_fork_travle,
              front_suspension_price: @bike_type.front_suspension_price,
              base_price: @bike_type.base_price,
              commsission: @bike_type.commsision
            }.merge(params))
          end
        end
      end

      class Step8 < Step7
        #  ╓                                                                                                  ╖
        #  ║         upgrade時にタイプオブジェクトを解釈するのではなく、                                      ║
        #  ║         「メソッドの抽出」を使ってアップグレードできる引数をカプセル化することができる           ║
        #  ╙                                                                                                  ╜
        class RigidMountainBike
          # attr_reader :tire_width, :front_fork_travel, :front_suspension_price, :base_price, :commssion

          def upgradable_parameters
            {
              tire_width: @tire_width,
              base_price: @base_price,
              commission: @commission
            }
          end
        end

        class FrontSuspensionMountainBike
          # attr_reader :tire_width, :front_fork_travel, :front_suspension_price, :base_price, :commssion

          def upgradable_parameters
            {
              tire_width: @tire_width,
              front_fork_travel: @front_fork_travel,
              front_suspension_price: @front_suspension_price,
              base_price: @base_price,
              commission: @commission
            }
          end
        end

        class MountainBike
          def add_front_suspension(params)
            @bike_type = FrontSuspensionMountainBike.new(
              @bike_type.upgradable_parameters.merge(params)
            )
          end

          def add_rear_suspension(_params)
            unless @bike_type.is_a?(FrontSuspensionMountainBike)
              raise "You can't add rear suspension unless you have front suspension"
            end

            @bike_type = FullSuspensionMountainBike.new(
              @bike_type.upgradable_parameters.merge(params)
            )
          end
        end
      end
    end
  end
end
