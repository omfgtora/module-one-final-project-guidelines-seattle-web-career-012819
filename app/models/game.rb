class Game < ActiveRecord::Base
  has_many :game_records
  belongs_to :player

  def choose_random_artist(song)
    Artist.where.not(name: song.artist.name).sample.name
  end

  def lyrics_to_array(song)
    song["lyrics"].split("\r\n").delete_if { |line| line.empty? }
  end

  def choose_lyrics_line(lyrics_array)
    random_index = rand(0..lyrics_array.size - 2)
    lyrics_array[random_index..(random_index + 1)]
  end

  def create_question_set(question_ct)
    question_ct.times.collect {generate_question}
  end

  def generate_question
    song = Song.all.sample
    song_id = song[:id]
    guessing_lyric = choose_lyrics_line(lyrics_to_array(song)).join("\n")
    correct_answer = song.artist.name
    incorrect_answers = 3.times.collect {choose_random_artist(song)}
    display_answers = (incorrect_answers + [correct_answer]).shuffle

    question = {
      song_id: song_id,
      guessing_lyric: guessing_lyric,
      correct_answer: correct_answer,
      incorrect_answers: incorrect_answers,
      display_answers: display_answers
    }

    question
  end

  def ask_questions(question_ct)
    question_set = create_question_set(question_ct)

    question_set.each do |question|
      display_question(question)

      response = gets.chomp.to_i
      loop do
        if !([1, 2, 3, 4].include? response)
          puts "Please give an answer between 1 and 4."
          response = gets.chomp.to_i
        else
          break
        end
      end

      response_artist = question[:display_answers][response - 1]
      save_answered_question(question, response_artist)
      display_correct_answer_and_score(question)
      sleep 2
      system("clear")
      display_correct_answer_and_score(question)
    end
  end

  def display_question(question)
    puts "\nWho sang these lyrics?".center(80)
    puts "\n#{question[:guessing_lyric]}\n\n".center(80)
    question[:display_answers].each_with_index { |answer, i| puts "#{i + 1}. #{answer}" }
  end

  def score_response(player_response, answer)
    player_response == answer ? 10 : 0
  end

  def save_answered_question(question, response)
    saved_question = GameRecord.create
    saved_question.song_id = question[:song_id]
    saved_question.points = score_response(response, question[:correct_answer])
    saved_question.game_id = self.id
    saved_question.save
  end

  def display_correct_answer_and_score(question)
    puts "\nThe correct answer is #{question[:correct_answer]}"
    puts "You scored #{self.game_records.last.points} points!\n\n"
  end

  def show_ending_game_score
    game_over_text = generate_ascii("Game Over")
    longest_line = longest_line = game_over_text.split("\n").max_by(&:size).size
    game_score = self.game_records.sum("points").to_s

    system("clear")
    puts game_over_text
    puts "You Scored".center(longest_line)
    generate_ascii(game_score).split("\n").each { |line| puts line.center(longest_line) }
    puts "Points!".center(longest_line)
  end

  def self.display_leaderboard
    system("clear")
    generate_ascii("Top 10").split("\n").each { |line| puts line.center(60) }

    total_scores = Player.all.each_with_object({}) do |player, ttl_score|
      ttl_score[player.name] = player.game_records.sum("points")
    end

    puts "\n"

    if total_scores.length > 0
      longest_name_length = total_scores.max_by { |k, v| k.length }.first.length
      puts "#{"Player".ljust(longest_name_length)} \| #{"Score".rjust(4)}".center(60)
      puts ("-" * 20).center(60)

      total_scores = total_scores.sort_by { |k, v| -v }
      total_scores.first(10).each do |plr_scr|
        puts "#{plr_scr[0].ljust(longest_name_length)} \| #{plr_scr[1].to_s.rjust(4)}".center(60)
      end
    else
      puts "There are no players to display"
    end
  end
end
