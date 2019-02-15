class Player < ActiveRecord::Base
  has_many :games
  has_many :game_records, through: :games

  def get_total_history
    total_points = self.game_records.sum(:points)
    question_ct = self.game_records.group("points > 0").count
    new_hash = {}
    new_hash = {points: total_points.to_s, correct_ct: question_ct[0].to_s, incorrect_ct: question_ct[1].to_s}
  end

end
