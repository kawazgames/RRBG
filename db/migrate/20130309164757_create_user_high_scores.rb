class CreateUserHighScores < ActiveRecord::Migration
  def change
    create_table :user_high_scores do |t|
      t.references :user
      t.references :high_score_partition
      t.integer :score

      t.timestamps
    end
    add_index :user_high_scores, :user_id
  end
end
