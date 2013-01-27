class Rank < ActiveRecord::Base
  belongs_to :user
  attr_accessible :rank, :score ,:user_id
  
  #・スコアテーブルに今の値より小さいのがいるか確認（ロックなし）
  #・なかったらなにもしない
  #・あったら、スコアテーブル全体にREADロック(LICK IN SHARE MODE)でデータとる
  #・更新対象をアップデート
  #・スコアリストを返す  
  
  RANK_MAX = 10
  def self.save_score(score,user)
    ranks = Rank.find(:all,lock:true)
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
    
   ranks
  end
  
end

