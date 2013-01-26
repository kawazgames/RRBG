class CreateMaps < ActiveRecord::Migration
  def change
    create_table :maps do |t|
      t.references :stage
      t.integer :type
      t.integer :x
      t.integer :y
      t.string :move_type

      t.timestamps
    end
    add_index :maps, :stage_id
  end
end
