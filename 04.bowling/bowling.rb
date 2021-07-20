# frozen_string_literal: true

# calculation of your bowling score
class Bowling
  def self.calc_points(score)
    my_score = Bowling.new(score)
    my_score.total_points
  end

  def initialize(score)
    @scores = score[0].split(',').flat_map { |s| s == 'X' ? [10, 0] : s.to_i }
    @basic_score = @scores.each_slice(2).to_a
  end

  def total_points
    @scores.sum + points_of_strikes + points_of_spares
  end

  def points_of_strikes
    ary_for_strike_points.sum
  end

  def points_of_spares
    numbers_for_spare_calc.sum { |n| n < 9 ? @basic_score[n + 1][0] : 0 }
  end

  private

  def numbers_for_strike_calc
    @basic_score.filter_map.with_index do |frame, index|
      condition_for_strike_calc = frame[0] == 10 && index < 9
      index if condition_for_strike_calc
    end
  end

  def ary_for_strike_points
    numbers_for_strike_calc.map! do |index|
      if @basic_score[index + 1][0] == 10
        10 + @basic_score[index + 2][0]
      else
        @basic_score[index + 1].sum
      end
    end
  end

  def numbers_for_spare_calc
    @basic_score.filter_map.with_index do |frame, index|
      condition_for_spare_calc = frame.sum == 10 && frame[1] != 0
      index if condition_for_spare_calc
    end
  end
end

p Bowling.calc_points(ARGV)
