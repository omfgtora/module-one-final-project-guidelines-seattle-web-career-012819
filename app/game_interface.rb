$longest_line = nil

def welcome
  guess_from = generate_ascii("Guess  From")
  $longest_line = $longest_line = guess_from.split("\n").max_by(&:size).size
  puts guess_from
  generate_ascii("Lyrics").split("\n").each { |line| puts line.center($longest_line) }
end

def menu
  puts "\n"
  menu = ["New Game", "Leaderboard", "Player History"]
  menu.each { |menu_item| puts "".ljust($longest_line / 3) + "#{menu.index(menu_item) + 1} - #{menu_item}".ljust($longest_line / 3) }
  puts "".ljust($longest_line / 3) + "0 - Exit Game"
  get_menu_input()
end

def thank_you_for_playing
  system("clear")
  puts generate_ascii("Thank you")
  puts generate_ascii("for playing.")
  ""
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

def play_game(current_player)
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
      play_game(current_player)
    else
      break
    end
  end
end

def display_user_history
  puts "Whose history would you like to see?"
  user_name = gets.chomp
  display_user = Player.find_by(name: user_name)
  linewidth = 80

  if display_user
    system("clear")
    generate_ascii(display_user.name).split("\n").each { |line| puts line.center(linewidth) }
    puts "Game".ljust(linewidth / 5) + "Score".ljust(linewidth / 5) + "Correct Answers".ljust(linewidth / 4) + "Incorrect Answers".ljust(linewidth / 4)
    puts "-" * linewidth

    display_user.games.each_with_index do |game, idx|
      score = game.game_records.sum(:points).to_s
      correct_ct = game.game_records.group("points > 0").count[1].to_i.to_s
      incorrect_ct = game.game_records.group("points > 0").count[0].to_i.to_s
      puts "#{("Game " + (idx + 1).to_s).ljust(linewidth / 5)} #{score.ljust(linewidth / 5)} #{correct_ct.ljust(linewidth / 4)} #{incorrect_ct.ljust(linewidth / 4)}"
    end

    puts "." * 80
    total_row = display_user.get_total_history
    puts "#{("All Games").ljust(linewidth / 5)} #{total_row[:points].ljust(linewidth / 5)} #{total_row[:correct_ct].ljust(linewidth / 4)} #{total_row[:incorrect_ct].ljust(linewidth / 4)}"
  else
    puts "That user wasn't found."
  end
end
