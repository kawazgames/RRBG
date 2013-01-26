class CreateEnemyLeukocytes < ActiveRecord::Migration
  def change
    create_table :enemy_leukocytes do |t|
      t.references :user_game
      t.integer :x
      t.integer :y

      t.timestamps
    end
    add_index :enemy_leukocytes, :user_game_id
  end
end
