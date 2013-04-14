class CreateHighScorePartitions < ActiveRecord::Migration
  def change
    create_table :high_score_partitions do |t|
      t.integer :min
      t.integer :max
      t.integer :user_count, default: 0

      t.timestamps
    end
  end
end
