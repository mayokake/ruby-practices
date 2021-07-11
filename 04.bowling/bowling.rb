#!/Users/masataka_ikeda/.rbenv/versions/3.0.1/bin/ruby
# frozen_string_literal: true

class Bowling
  def initialize(score)
    @score = score
  end

  def scores
    @score[0].split(',')
  end

  def basic_scores
    shots = []
    scores.each { |sc| sc == 'X' ? shots.push(10, 0) : shots.push(sc.to_i) }
    shots
  end

  def array_for_spare
    spares = []
    basic_scores.each_slice(2) { |s| spares.push(s) }
    spares
  end

  def spare_frames
    s_frames = []
    array_for_spare.each_index do |index|
      s_frames.push(index) if array_for_spare[index].sum == 10 && array_for_spare[index][1] != 0
    end
    s_frames
  end

  def points_in_spares
    spare_score = 0
    spare_frames.each { |n| spare_score += array_for_spare[n + 1][0] if n != 9 }
    spare_score
  end

  def array_for_strike
    shots_for_strike = []
    scores.each { |s| s == 'X' ? shots_for_strike.push(10) : shots_for_strike.push(s.to_i) }
    shots_for_strike
  end

  def strikes
    scores.each_index.select { |i| scores[i] == 'X' }
  end

  def point(str)
    array_for_strike[str]
  end

  def strike_points_extra(strx)
    point(strx + 1) + point(strx + 2)
  end

  def score_in_strike
    points_strike = 0
    strikes.each do |num|
      points_strike += strike_points_extra(num) if !point(num + 2).nil? && !point(num + 3).nil?
    end
    points_strike
  end
end

my_score = Bowling.new(ARGV)
p my_score.basic_scores.sum + my_score.points_in_spares + my_score.score_in_strike
