class SessionController < ApplicationController
  def new
  end

  def create
    user = User.find_by(username: params[:username])
    if (user && user.authenticate(params[:password]))
      session[:current_user_id] = user.id
      flash[:notice] = "Logged in"
    else
      flash.now[:error] = 'Invalid username or password'
    end
  end

  def destroy
    session[:current_user_id] = nil
  end
end
