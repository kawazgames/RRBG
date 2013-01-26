class CreateUserFungus < ActiveRecord::Migration
  def change
    create_table :user_fungus do |t|
      t.references :user_game
      t.integer :x
      t.integer :y

      t.timestamps
    end
    add_index :user_fungus, :user_game_id
  end
end
