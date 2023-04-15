class UserController < ApplicationController

  def new
    flash[:alert] = nil
    flash[:notice] = nil
  end

  def index
  end

  def create
    check_existed_user = User.find_by(username: params[:username])
    if (check_existed_user)
      flash[:alert] = "Username already created"
      @user = User.new(username: user_params[:username])
      return render :new
    end

    if (user_params[:password] != user_params[:password_confirmation])
      flash[:alert] = "Wrong confirmation password"
      @user = User.new(username: user_params[:username])
      return render :new
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
