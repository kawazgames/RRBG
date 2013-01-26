class CreateGameMaps < ActiveRecord::Migration
  def change
    create_table :game_maps do |t|
      t.references :game_stage
      t.integer :type
      t.integer :x
      t.integer :y

      t.timestamps
    end
    add_index :game_maps, :game_stage_id
  end
end
