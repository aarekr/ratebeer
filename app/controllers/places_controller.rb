class PlacesController < ApplicationController
  before_action :set_place, only: [:show, :edit, :update, :destroy]

  def index
  end

  def show
  end

  def search
    key = "..." # sää-key
    url = "http://api.weatherstack.com/current"
    response = HTTParty.get "#{url}?access_key=#{key}&query=#{ERB::Util.url_encode(params[:city])}"

    @kaupunki = response["location"]["name"]
    @lampotila = response["current"]["temperature"]
    @saa_ikoni = response["current"]["weather_icons"]
    @wind_speed = response["current"]["wind_speed"]
    @wind_dir = response["current"]["wind_dir"]

    @places = BeermappingApi.places_in(params[:city])
    session[:vika_haku] = @places
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      render :index, status: 418
    end
  end

  def set_place
  end
end
