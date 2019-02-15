require 'bundler/setup'
Bundler.require

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: "db/guess_from_lyrics.sqlite"
)

ActiveRecord::Base.logger = nil

require_all 'app'
# require 'rest-client'
require "uri"
require "net/http"
require 'rake'
