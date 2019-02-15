def generate_ascii(text)
  url = URI("https://artii.herokuapp.com/make?text=" + text)
  https = Net::HTTP.new(url.host, url.port)
  https.use_ssl = true

  request = Net::HTTP::Get.new(url)

  response = https.request(request)
  response.body
end
