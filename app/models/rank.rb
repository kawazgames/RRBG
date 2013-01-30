class Rank < ActiveRecord::Base
  belongs_to :user
  attr_accessible :rank, :score ,:user_id

  # Rankテーブルすべてを取得しJSONとして返却します。
  # @return [JSON]
  def self.find_all_to_json
    result = {}
    result[:ranking]  = []
    ranking = repack_rank_attr_to_array Rank.find(:all)
    result[:ranking].push ranking
    result.to_json
  end

  ###
  # API仕様にそうようにArrayにつめ替えます
  ###
  def self.repack_rank_attr_to_array(ranks)
    ranking = []
    ranks.each do |r|
      rank = {}
      rank[:rank] = r.rank
      rank[:score] = r.score
      auth = Authentication.find_by_user_id(r.user_id)
      unless auth.nil?
        rank[:screen_name]  = auth.screen_name
        rank[:image_url]  = auth.image_url
      else
        # DB整合が確かならばここには来ないはず
        raise ArgumentError, "invalid argument Database => user_id"
      end
      ranking.push rank
    end
    ranking
  end

  RANK_MAX = 10

  #  スコア判定をおこなってセーブをするかを決定します。
  # @param score [Integer] スコアデータ
  # @param user [User] ユーザーデータ ユーザーIDを使用
  # @return [JSON]
  def self.save_score(score,user)
    Rank.transaction {
      ranks = Rank.find(:all,lock:'LOCK IN SHARE MODE')
      @temp_rank = 0

      ranks.each_with_index do |r,index|
        next_rank = ranks[index+1]
        next_rank = ranks[index] if ranks[index+1] == nil

        #ランキング内に入っているか比較
        unless r.score == score
          if r.score > score && next_rank.score <= score
            @temp_rank = r.rank
          end
        end
      end

      unless @temp_rank == 0
        ranks[@temp_rank].update_attributes!({score:score,user_id:user.id})
      end
      result = []
      result[:ranking] =  repack_rank_attr_to_array ranks
      return result.to_json
    }
  end

end

