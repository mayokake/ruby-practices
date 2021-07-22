#!/Users/masataka_ikeda/.rbenv/versions/3.0.1/bin/ruby
# frozen_string_literal: true

class BowlingGame
  LAST_FRAME_INDEX = 9

  def self.total_score(score)
    bowling_game = BowlingGame.new(score)
    bowling_game.total_score
  end

  def initialize(score)
    @scores = score.split(',').flat_map { |s| s == 'X' ? [10, 0] : s.to_i }
    @basic_score = @scores.each_slice(2).to_a
  end

  def total_score
    @scores.sum + strike_bonus_point + spare_bonus_point
  end

  private

  def strike_bonus_point
    frame_number_for_strike.sum do |index|
      if @basic_score[index + 1][0] == 10
        10 + @basic_score[index + 2][0]
      else
        @basic_score[index + 1].sum
      end
    end
  end

  def spare_bonus_point
    frame_number_for_spare.sum { |n| @basic_score[n + 1][0] }
  end

  def frame_number_for_strike
    @basic_score.filter_map.with_index do |frame, index|
      condition_for_strike_calc = frame[0] == 10 && index < LAST_FRAME_INDEX
      index if condition_for_strike_calc
    end
  end

  def frame_number_for_spare
    @basic_score.filter_map.with_index do |frame, index|
      condition_for_spare_calc = frame.sum == 10 && frame[1] != 0 && index < LAST_FRAME_INDEX
      index if condition_for_spare_calc
    end
  end
end

p BowlingGame.total_score(ARGV[0])
