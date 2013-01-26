class CreateUserFungus < ActiveRecord::Migration
  def change
    create_table :user_fungus do |t|
      t.references :game_stage
      t.integer :x
      t.integer :y

      t.timestamps
    end
    add_index :user_fungus, :game_stage_id
  end
end
