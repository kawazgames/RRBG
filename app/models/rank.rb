class Rank < ActiveRecord::Base
  belongs_to :user
  attr_accessible :rank, :score ,:user_id
  
  def self.find_all_to_json
    tmp_ranking = Rank.find(:all)
    ranking = []
    tmp_ranking.each do |r|
      rank = {}
      rank[:rank] = r.rank
      rank[:score] = r.score
      auth = Authentication.find_by_user_id(r.user_id)
      unless auth.nil?
        rank[:screen_name]  = auth.screen_name
        rank[:image_url]  = auth.image_url
      else
        rank[:user_id] = r.user_id
        rank[:auth] = auth
      end
      ranking.push rank
    end
    ranking.to_json
  end
  
  RANK_MAX = 10
  def self.save_score(score,user)
    Rank.transaction {
      ranks = Rank.find(:all,lock:'LOCK IN SHARE MODE')
      @temp_rank = 0

      ranks.each_with_index do |r,index|
        next_rank = ranks[index+1] 
        next_rank = ranks[index] if ranks[index+1] == nil

        unless r.score == score
          if r.score > score && next_rank.score <= score
            @temp_rank = r.rank
          end
        end
      end

      unless @temp_rank == 0
        ranks[@temp_rank].update_attributes!({score:score,user_id:user.id})
      end
    }
    ranks
  end
  
end

