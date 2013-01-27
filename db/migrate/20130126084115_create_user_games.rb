class CreateUserGames < ActiveRecord::Migration
  def change
    create_table :user_games do |t|
      t.references :user
      t.references :game_stage
      t.integer :status
      t.string :game_object_type
      t.integer :game_object_id

      t.timestamps
    end
    add_index :user_games, :user_id
    add_index :user_games, :game_stage_id
  end
end
