class CreateEnemyLeukocytes < ActiveRecord::Migration
  def change
    create_table :enemy_leukocytes do |t|
      t.references :game_stage
      t.integer :x
      t.integer :y

      t.timestamps
    end
    add_index :enemy_leukocytes, :game_stage_id
  end
end
