class UserHighScore < ActiveRecord::Base
  belongs_to :user
  belongs_to :high_score_partition
  attr_accessible :score

  after_save do |r|
    partition = HighScorePartition.target(r.score).lock("LOCK IN SHARE MODE").first
    # Not partition if cheat?
    raise "Score not range partition" unless partition
    # Not modify
    return true if partition.id == r.high_score_partition_id
    # Remove user for old pertition
    self.high_score_partition.decrement!(:user_count) if self.high_score_partition
    # Add user for new partition
    partition.increment! :user_count
    # New partition
    r.high_score_partition = partition
    r.save!
  end

  def current_rank
    total = HighScorePartition.upper(self.score).sum(:user_count)
    range = self.class.upper_byrange(self.score).count(:score)
    total + range + 1
  end

  def self.upper_byrange score
    target = HighScorePartition.target(score).first
    self.where(score: (score+1)..target.max)
  end

end
