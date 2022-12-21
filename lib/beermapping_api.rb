class BeermappingApi
  def self.places_in(city)
    city = city.downcase

    Rails.cache.fetch(city, expires_in: 10) {
      get_places_in(city)
    }
  end

  def self.get_places_in(city)
    # puts "*** tultiin get_places_in -funktioon"
    url = "http://beermapping.com/webservice/loccity/#{key}/"

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
    # puts "*** BeermappingApi response: #{response}"
    places = response.parsed_response["bmp_locations"]["location"]
    # puts "*** BeermappingApi places: #{places}"

    return [] if places.is_a?(Hash) && places['id'].nil?

    places = [places] if places.is_a?(Hash)
    places.map do |place|
      puts "*** BeermappingApi place: #{place}"
      Place.new(place)
    end
  end

  def self.get_rafla_by_id(rafla_id)
    puts "*** GET RAFLA, id: #{rafla_id}, #{Rails.cache.fetch(rafla_id)}"
  end

  def self.key
    "ddd910aa0b5ef3abdcca0736426a237d"
    # return nil if Rails.env.test? # testatessa ei apia tarvita, palautetaan nil
    # raise 'BEERMAPPING_APIKEY env variable not defined' if ENV['BEERMAPPING_APIKEY'].nil?
    # ENV.fetch('BEERMAPPING_APIKEY')
  end
end
