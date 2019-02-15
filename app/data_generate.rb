def get_all_songs_with_(header)
  url = URI("https://musicdemons.com/api/v1/song")
  https = Net::HTTP.new(url.host, url.port)
  https.use_ssl = true

  request = Net::HTTP::Get.new(url)
  request["with"] = header

  response = https.request(request)
end

def convert_songs_to_json(header)
  # take HTTPOK response and convert to json
  JSON.parse(get_all_songs_with_(header).body)
end

def flatten_artists(songs_array)
  songs_array.each do |song, arr|
    song["artists"] = song["artists"].map { |artist| artist["name"] }.join(" & ")
  end
end

def merge_lyrics_songs(songs, lyrics)
  songs.each_with_object([]) do |song, new_arr|
    song_lyrics = lyrics.select { |elmt| elmt["id"] == song["id"] }.first
    new_arr << song.merge(song_lyrics)
  end
end

def remove_no_lyric_songs(songs_array)
  songs_array.delete_if { |song| song["lyrics"].empty? }
end

def seed_songs_and_artists(songs_array)
  songs_array.each do |song|
    new_song = Song.create(title: song["title"], lyrics: song["lyrics"][0]["lyrics"])
    new_song.release_date = Date.strptime(song["released"], '%m/%d/%Y') if song["released"]

    new_artist = Artist.find_or_create_by(name: song["artists"])
    new_song.artist_id = new_artist.id

    new_song.save
  end
end
