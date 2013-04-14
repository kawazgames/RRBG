class HighScorePartition < ActiveRecord::Base
  attr_accessible :id, :max, :min, :user_count

  def self.target score
    self.where("(min <= ? AND ? <= max)", score, score)
  end

  def self.upper score
    self.where("min > ?", score)
  end

  def self.upper_byrange score
    target = self.target(score).first
    self.where(user_count: score..target.max)
  end

end
