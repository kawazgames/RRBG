class AddEnemyLeukocyteStatus < ActiveRecord::Migration
  def change
    add_column :enemy_leukocytes, :status, :integer
    add_index :enemy_leukocytes, :status
  end
end
