class AddUserFungusStatus < ActiveRecord::Migration
  def change
    add_column :user_fungus, :status, :integer
    add_index :user_fungus, :status
  end
end
