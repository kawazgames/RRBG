class CreateFungus < ActiveRecord::Migration
  def change
    create_table :fungus do |t|
      t.integer :reproductive_turns
      t.integer :move_type

      t.timestamps
    end
  end
end
