class BeermappingApi
  def self.places_in(city)
    city = city.downcase

    puts "*** haetaan paikkaa"
    Rails.cache.fetch(city, expires_in: 10) {
      puts "*** cache.fetch -funtkiossa"
      get_places_in(city)
    }
  end

  def self.get_places_in(city)
    puts "*** tultiin get_places_in -funktioon"
    url = "http://beermapping.com/webservice/loccity/#{key}/"

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
    # puts "*** BeermappingApi response: #{response}"
    places = response.parsed_response["bmp_locations"]["location"]
    # puts "*** BeermappingApi places: #{places}"

    return [] if places.is_a?(Hash) && places['id'].nil?

    places = [places] if places.is_a?(Hash)
    places.map do |place|
      Place.new(place)
    end
  end

  def self.key
    "731955affc547174161dbd6f97b46538"
  end
end