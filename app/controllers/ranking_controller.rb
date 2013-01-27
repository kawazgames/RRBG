class RankingController < ApplicationController
  def index
    tmp_ranking = Rank.find(:all)
    ranking = []
    tmp_ranking.each do |r|
      rank = {}
      rank[:rank] = r.rank
      rank[:score] = r.score
      auth = Authentication.find_by_user_id(r.user_id)
      rank[:screen_name]  = auth.screen_name
      rank[:image_url]  = auth.image_url
      ranking.push rank
    end
    render :json => ranking.to_json
  end
  
  def save
    user = User.new
    user.id = 1
    ranking = Rank.save_score(10000,user)
    render :json => ranking.to_json
  end
  
end
