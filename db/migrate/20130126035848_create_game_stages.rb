class CreateGameStages < ActiveRecord::Migration
  def change
    create_table :game_stages do |t|

      t.timestamps
    end
  end
end
