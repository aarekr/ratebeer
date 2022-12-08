class SessionsController < ApplicationController
  def new
    #@users = User.all
    #@session = User.new
  end

  def create
    puts "tullaan session_controlleriin"
    user = User.find_by username: params[:username]
    puts "session_controller user: #{user}"
    # talletetaan sessioon kirjautuneen käyttäjän id (jos käyttäjä on olemassa)
    session[:user_id] = user.id if user # not user.nil?
    puts "session_controller user_id: #{user_id}"
    puts "session_controller session: #{session}"
    redirect_to user
  end

  def destroy
    session[:user_id] = nil
    redirect_to :root
  end
end
