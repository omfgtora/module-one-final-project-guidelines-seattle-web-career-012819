class Player < ActiveRecord::Base
  has_many :games
  has_many :game_records, through: :games

  def get_total_history
    result = {
      points: self.game_records.sum(:points).to_s,
      correct_ct: self.game_records.where("points > 0").count.to_s,
      incorrect_ct: self.game_records.where(points: 0).count.to_s
    }
  end

end
