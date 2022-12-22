class PlacesController < ApplicationController
  before_action :set_place, only: [:show, :edit, :update, :destroy]

  def index
  end

  def show
    '''
    puts "*** SHOW ravintolan id: #{params[:id]}"
    puts "*** SHOW @ravintola: #{params[:id]}"

    response = HTTParty.get "#{url}"
    puts "*** SÄÄ RESPONSE: #{response}"
    puts "*** SÄÄ RESPONSE location: #{response['location']}"
    puts "*** SÄÄ RESPONSE location name: #{response['location']['name']}"
    puts "*** SÄÄ RESPONSE current temperatue: #{response['current']['temperature']}"
    puts "*** SÄÄ RESPONSE current wind_speed: #{response['current']['wind_speed']}"
    puts "*** SÄÄ RESPONSE current wind_dir: #{response['current']['wind_dir']}"
    puts "*** SÄÄ RESPONSE current: #{response['current']}"

    @kaupunki = response['location']['name']
    @lampotila = response['current']['temperature']
    @saa_ikoni = response['current']['weather_icons']
    @wind_speed = response['current']['wind_speed']
    @wind_dir = response['current']['wind_dir']
    puts "*** SÄÄ RESPONSE @kaupunki: #{@kaupunki}"
    '''
  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    session[:vika_haku] = "#{@places}"
    puts "*** SEARCH session: #{session[:vika_haku]}"
    puts "*** SEARCH session toka: #{session[:vika_haku].class}"
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      render :index, status: 418
    end
  end

  def set_place
  end
end
