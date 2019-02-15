require_relative "../config/environment"
# require_relative "./cli.rb"

# def rake(*tasks)
#   tasks.each { |task| Rake.application[task].tap(&:invoke).tap(&:reenable) }
# end

# not a robust check, good enough for now
# exec("ruby ../db/seeds.rb") if Song.none?
require_relative "../db/seeds.rb" if Song.none?

welcome
menu
loop do
  puts "-" * 80
  puts "Press enter to return to main menu"
  gets.chomp
  system("clear")
  welcome
  menu
end
