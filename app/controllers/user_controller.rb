class UserController < ApplicationController

  def new
  end

  def index
  end

  def create
    if (user_params[:password] != user_params[:password_confirmation])
      return flash[:alert] = "Wrong confirmation password"
    end

    @user = User.new(user_params)
    if (@user.save)
      session[:current_user_id] = @user.id
      flash[:notice] = "User created."
      redirect_to root_path
    end
  end

  private
  def user_params
    params.permit(:username, :password, :password_confirmation)
  end
end
