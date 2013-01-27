class UserGameExistsUserFungusValidato < ActiveRecord::Validator
  def validate
    uf = UserFungus.where(user_game: record.user_game, x: record.x, y: record.y).first(lock: true)
    unless uf.nil?
      record.errors[:x] << "Exists UserFungus"
    end
  end
end
