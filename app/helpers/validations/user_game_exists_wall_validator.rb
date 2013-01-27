class UserGameExistsWallValidator < ActiveRecord::Validator
  def validate
    el = EnemyLeukocyte.where(user_game: record.user_game, x: record.x, y: record.y).first(lock: true)
    unless el.nil?
      record.errors[:x] << "Exists EnemyLeukocyte"
    end
  end
end
