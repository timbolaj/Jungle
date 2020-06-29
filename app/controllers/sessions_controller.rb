class SessionsController < ApplicationController
  def new
  end

  def create
    # user = User.new
    # if user.authenticate_with_credentials(params[:email], params[:password])
    p params[:password]
    if user = User.authenticate_with_credentials(params[:sessions][:email], params[:sessions][:password])
      session[:user_id] = user.id 
      redirect_to '/'
    else
      redirect_to "/login"
      flash.alert = "User not found!"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/login'
  end

end
