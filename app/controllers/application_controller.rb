class ApplicationController < ActionController::Base

  def authenticate_user!
    unless current_user
      return
    end
  end

  def current_user
    @current_user ||= User.find_by(id: session[:current_user_id])
  end

end
