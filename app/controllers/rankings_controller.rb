class RankingsController < ApplicationController
  respond_to :json
  def index
    respond_with Rank.find_all_to_json
  end
  
  def save
    user = User.new
    user.id = 1
    ranking = Rank.save_score(10000,user)
    render :json => ranking.to_json
  end
  
end
