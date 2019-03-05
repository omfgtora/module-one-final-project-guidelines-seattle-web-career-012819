$longest_line = nil

def welcome
  guess_from = generate_ascii("Guess  From")
  $longest_line = guess_from.split("\n").max_by(&:size).size
  puts guess_from
  generate_ascii("Lyrics").split("\n").each { |line| puts line.center($longest_line) }
end

def menu
  puts "\n"
  menu = {"New Game" => 1, "Leaderboard" => 2, "Player History" => 3, "Exit Game" => 0}
  menu.each do |menu_item, index|
    puts "#{"".ljust($longest_line / 3)}#{index} - #{menu_item.ljust($longest_line / 3)}"
  end
  get_menu_input()
end

def get_menu_input(arg = nil)
  if arg == "try again"
    puts "Please input a command"
  end

  input = gets.chomp

  case input
  when "1"
    current_player = ask_player_name
    play_game(current_player)
    continue(current_player)
  when "2"
    Game.display_leaderboard
  when "3"
    display_user_history
  when "0" then abort(thank_you_for_playing)
  else get_menu_input("try again")
  end
end

def thank_you_for_playing
  system("clear")
  puts generate_ascii("Thank you")
  puts generate_ascii("for playing.")
  ""
end

def play_game(current_player)
  system("clear")
  new_game = Game.create
  new_game.player = current_player
  new_game.save
  new_game.ask_questions(5)
  new_game.show_ending_game_score
end

def ask_player_name
  puts "Who are you? Have we met before?"
  player_name = gets.chomp
  current_player = Player.find_or_create_by(name: player_name)
  puts "Nice to see you #{current_player.name}. Let's get started."
  current_player
end

def continue(current_player)
  loop do
    puts "\n\nWould you like to start a new game, #{current_player.name}? [Y/N]"
    input = gets.chomp.downcase

    if input == "y"
      system("clear")
      play_game(current_player)
    else
      system("clear")
      welcome
      menu
    end
  end
end

def display_in_four_columns(width, one, two, three, four)
  puts "#{one.ljust(width / 5)}#{two.ljust(width / 5)}#{three.ljust(width / 4)}#{four.ljust(width / 4)}"
end

def display_user_history
  puts "Whose history would you like to see?"
  user_name = gets.chomp
  display_user = Player.find_by(name: user_name)
  linewidth = 80

  if display_user
    system("clear")
    generate_ascii(display_user.name).split("\n").each { |line| puts line.center(linewidth) }

    display_in_four_columns(linewidth, "Game", "Score", "Correct Answers", "Incorrect Answers")

    puts "-" * linewidth

    display_user.games.each_with_index do |game, idx|
      score = game.game_records.sum(:points).to_s
      correct_ct = game.game_records.where("points > 0").count.to_s
      incorrect_ct = game.game_records.where(points: 0).count.to_s
      display_in_four_columns(linewidth, "Game #{idx + 1}", score, correct_ct, incorrect_ct)
    end

    puts "." * 80

    total_row = display_user.get_total_history
    display_in_four_columns(linewidth, "All Games", total_row[:points], total_row[:correct_ct], total_row[:incorrect_ct])
  else
    puts "That user wasn't found."
  end


end
