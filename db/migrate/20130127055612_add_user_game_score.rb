class AddUserGameScore < ActiveRecord::Migration
  def change
    add_column :user_games, :score, :integer
    add_index :user_games, :score
  end
end
