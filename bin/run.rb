require_relative "../config/environment"
# require_relative "./cli.rb"

# def rake(*tasks)
#   tasks.each { |task| Rake.application[task].tap(&:invoke).tap(&:reenable) }
# end

# not a robust check, good enough for now
# exec("ruby ../db/seeds.rb") if Song.none?
require_relative "../db/seeds.rb" if Song.none?

GameInterface.welcome
loop do
  GameInterface.menu
end
