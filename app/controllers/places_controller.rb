class PlacesController < ApplicationController
  before_action :set_place, only: [:show, :edit, :update, :destroy]

  def index
  end

  def show
  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    session[:vika_haku] = to_s
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

  def to_s
    "#{@places}"
  end
end
