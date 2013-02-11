class CreateRanks < ActiveRecord::Migration
  def change
    create_table :ranks do |t|
      t.integer :rank
      t.integer :score
      t.references :user

      t.timestamps
    end
    add_index :ranks, :user_id
  end
end
