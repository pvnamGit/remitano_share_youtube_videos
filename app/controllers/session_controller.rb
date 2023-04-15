class SessionController < ApplicationController
  def new
    flash[:alert] = nil
    flash[:notice] = nil
  end

  def create
    user = User.find_by(username: params[:username])
    if (user && user.authenticate(params[:password]))
      session[:current_user_id] = user.id
      flash[:notice] = "Logged in"
      redirect_to root_path
    else
      flash[:alert] = 'Invalid username or password'
      render :new
    end
  end

  def destroy
    session[:current_user_id] = nil
    redirect_to root_path
  end
end
