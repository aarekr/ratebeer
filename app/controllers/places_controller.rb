class PlacesController < ApplicationController
  before_action :set_place, only: [:show, :edit, :update, :destroy]

  def index
  end

  def show
    puts "*** SHOW ravintolan id: #{params[:id]}"
    @ravintola = BeermappingApi.get_rafla_by_id(params[:id])
    puts "*** SHOW @ravintola: #{params[:id]}"
    # @session[:vika_haku]
  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    # puts "*** SEARCH: #{@places}"
    # puts "*** SEARCH.first: #{@places.first}"
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
    @ravintola = BeermappingApi.get_rafla_by_id(params[:id])
    puts "*** set_place @ravintola: #{@ravintola}"
  end
end
