class RatingsController < ApplicationController
  def index
    @ratings = Rating.all
    @aktiivisimmat = most_active_users
    @viimeiset_viisi = recent_ratings
    @parhaat_tyylit = best_styles
    @parhaat_oluet = best_beers
    @parhaat_panimot = best_breweries
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)
    @rating.user = current_user

    if @rating.save
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    rating = Rating.find(params[:id])
    rating.delete if current_user == rating.user
    redirect_to user_path(current_user)
  end

  def best_beers
    ranking = {}
    Rating.all.each do |r|
      luvut = [0.to_f, 0.to_f, 0.to_f] # keskiarvo, pisteet, lkm
      ranking[r.beer.name] = luvut if !ranking.include?(r.beer.name)
      ranking[r.beer.name][1] += r.score
      ranking[r.beer.name][2] += 1
      ranking[r.beer.name][0] = ranking[r.beer.name][1] / ranking[r.beer.name][2]
    end
    ranking.sort_by(&:second).reverse[0..2]
  end

  def best_breweries
    ranking = {}
    Rating.all.each do |r|
      luvut = [0.to_f, 0.to_f, 0.to_f] # keskiarvo, pisteet, lkm
      ranking[r.beer.brewery.name] = luvut if !ranking.include?(r.beer.brewery.name)
      ranking[r.beer.brewery.name][1] += r.score
      ranking[r.beer.brewery.name][2] += 1
      ranking[r.beer.brewery.name][0] = ranking[r.beer.brewery.name][1] / ranking[r.beer.brewery.name][2]
    end
    ranking.sort_by(&:second).reverse[0..2]
  end

  def best_styles
    ranking = {}
    Rating.all.each do |reittaus|
      luvut = [0.to_i, 0.to_i, 0.to_i] # keskiarvo, pisteet, lkm
      ranking[reittaus.beer.style] = luvut if !ranking.include?(reittaus.beer.style)
      ranking[reittaus.beer.style][1] += reittaus.score
      ranking[reittaus.beer.style][2] += 1
      ranking[reittaus.beer.style][0] = ranking[reittaus.beer.style][1] / ranking[reittaus.beer.style][2]
    end
    ranking.sort_by(&:second).reverse[0..2]
  end

  def most_active_users
    ranking = {}
    Rating.all.each do |reittaus|
      username = (User.all.find_by id: reittaus.user_id).username
      ranking[username] = 0 if !ranking.include?(username)
      ranking[username] += 1
    end
    ranking.sort_by(&:second).reverse[0..2]
  end

  def recent_ratings
    taulu = [0, 0, 0, 0, 0]
    @ratings.each do |rating|
      taulu << "#{rating.beer} #{rating.score} #{rating.created_at}"
    end
    taulu[-5..]
  end
end
