class MembershipsController < ApplicationController
  before_action :set_membership, only: %i[show edit update destroy]
  # before_action :set_beer_clubs, only: %i[new edit create]

  # GET /memberships or /memberships.json
  def index
    @memberships = Membership.all
  end

  # GET /memberships/1 or /memberships/1.json
  def show
  end

  # GET /memberships/new
  def new
    @membership = Membership.new
    @beerclubs = Beerclub.all
  end

  # GET /memberships/1/edit
  def edit
  end

  # POST /memberships or /memberships.json
  def create
    jasenyys_olemassa = false; @memberships = Membership.all
    @memberships.each do |mem|
      jasenyys_olemassa = true if membership_params['beer_club_id'].to_i == mem['beer_club_id'].to_i && membership_params['user_id'].to_i == mem['user_id'].to_i
    end
    return unless jasenyys_olemassa == false

    @membership = Membership.new(membership_params)
    respond_to do |format|
      if @membership.save
        format.html { redirect_to beerclub_url('beer_club_id'), notice: "#{(User.find_by id: current_user.id).username} welcome to the club." }
        format.json { render :show, status: :created, location: @membership }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /memberships/1 or /memberships/1.json
  def update
    respond_to do |format|
      if @membership.update(membership_params)
        format.html { redirect_to membership_url(@membership), notice: "Membership was successfully updated." }
        format.json { render :show, status: :ok, location: @membership }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memberships/1 or /memberships/1.json
  def destroy
    puts "*** membership destroy funktio"
    @membership.destroy

    respond_to do |format|
      format.html { redirect_to user_url('user_id'), notice: "Membership was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_membership
    @membership = Membership.find(params[:id])
  end

  # def set_beer_clubs
  #  memberships_of_current = current_user.memberships.map(&:beerclub)
  #  @beer_clubs = BeerClub.where.not(id: memberships_of_current)
  # end

  # Only allow a list of trusted parameters through.
  def membership_params
    puts "*** membership_params funktio"
    # user_id = current_user.id
    params.require(:membership).permit(:beer_club_id, :user_id)
  end
end
