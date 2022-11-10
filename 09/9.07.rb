#                              ╔═══════════════════════════════════════╗
#                              ║ Replace Conditional with Polymorphism ║
#                              ║    条件分岐からポリモーフィズムへ     ║
#                              ╚═══════════════════════════════════════╝

class ReplaceConditionalWithPolymorphism
  #  ╓                                                                                                  ╖
  #  ║   オブジェクトのタイプによって振る舞いを変える条件文がある。                                                    ║
  #  ║   条件文の分岐先をポリモーフィックに呼び出せるオブジェクトのメソッドに移す                                          ║
  #  ╙                                                                                                  ╜
  class Example
    class MountainBike
      def price
        case @type_code
        when :figid
          (1 + @commission) * @base_price
        when :front_suspension
          (1 + @commission) * @base_price + @front_suspension_price
        when :full_suspenstion
          (1 + @commission) * @base_price + @front_suspension_price + @rear_suspension_price
        end
      end
    end
  end

  class Sample
    class Before
      module MountainBike
        def price
          case @type_code
          when :rigid
            (1 + @commission) * @base_price
          when :front_suspension
            (1 + @commission) * @base_price + @front_suspension_price
          when :full_suspension
            (1 + @commission) * @base_price + @front_suspension_price + @rear_suspension_price
          end
        end
      end

      class RigidMountainBike
        include MountainBike
      end

      class FrontSuspensionMountainBike
        include MountainBike
      end

      class FulluspensionMountainBike
        include MountainBike
      end
    end

    class Refactor
      module MountainBike
        def price
          case @type_code
          when :rigid
            raise 'should never get here'
          when :front_suspension
            (1 + @commission) * @base_price + @front_suspension_price
          when :full_suspension
            (1 + @commission) * @base_price + @front_suspension_price + @rear_suspension_price
          end
        end
      end

      class RigidMountainBike
        include MountainBike

        def price
          (1 + @commision) * @base_price
        end
      end
    end
  end
end
