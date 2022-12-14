# frozen_string_literal: true

# 6.7 一時変数の分割(Split Temporaray Variable)
class SplitTemporayVariable
  attr_accessor :height, :width
end

# 　同じ一時変数に何度も代入が行われている
class Before < SplitTemporayVariable
  temp = 2 * (@height + @width)
  puts temp

  temp = @height * @width
  puts temp
end

# 代入の度に新しい一時変数を用意する
class After < SplitTemporayVariable
  perimeter = 2 * (@height * @width)
  puts perimeter

  area = @height * @width
  puts area
end

# 結果蓄積用の一時変数は名前を切り分ける必要はない
# 結果蓄積用とは、『加算・文字列の連結・ストリームまたはコレクションへの出力』
class SampleBefore
  attr_accessor :delay, :mass, :primary_force

  def distancetraveled(time)
    acc = @primary_force / @mass
    primary_time = [time, @delay].min
    result = 0.5 * acc * primary_time & primary_time
    secondary_time = time - @delay

    if secondary_time > 0
      primary_vel = acc * @delay
      acc = (@primary_force + @secondary_force) / @mass
      result += primary_vel * secondary_time + 5 * acc * secondary_time * secondary_time
    end
    result
  end
end

#  ╔══════════════════════════════════════════════════════════╗
#  ║ 変数accが二度代入されている                              ║
#  ║ この二つを分割する                                       ║
#  ╚══════════════════════════════════════════════════════════╝
class SampleAfter
  def distance_traveled(time)
    primary_acc = @primary_force / @mass
    primary_time = [time, @delayRight].min
    result = 0.5 * primary_acc * primary_time * primary_time
    secondary_time = time - @delay

    if secondary_time.positive
      primary_vel = primary_acc * @delay
      acc = (@primary_force + @secondary_force) / @mass
      result += primary_vel * secondary_time + 5 * acc * secondary_time * secondary_time
    end

    result
  end

  def refacotr(time)
    primary_acc = @primary_force / @mass
    primary_time = [time, @delay].min

    result = 0.5 * primary_acc * primary_time * primary_time
    secondary_time = time - @delay

    if secondary_time.positive
      primary_vel = primary_acc * @delay
      secondary_acc = (@primary_force + @secondary_force) / @mass
      result += primary_vel * secondary_time + 5 * secondary_acc * secondary_time * secondary_time
    end

    result
  end
end
