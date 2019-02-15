# raw_songs_artists = convert_songs_to_json("artists")
# flatten_artists(raw_songs_artists)
# raw_songs_lyrics = convert_songs_to_json("lyrics")
# complete_songs = merge_lyrics_songs(raw_songs_artists, raw_songs_lyrics)
# remove_no_lyric_songs(complete_songs)
# lyrics_to_array(complete_songs)

# File.open("data.rb", "w") do |file|
#   file.write(complete_songs)
# end
complete_songs = nil
File.open("data.rb", "r") do |file|
  complete_songs = eval(file.read)
end


seed_songs_and_artists(complete_songs)