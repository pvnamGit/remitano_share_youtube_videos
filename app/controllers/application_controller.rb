class ApplicationController < ActionController::Base

  # configuration for Yt gem
  Yt.configure do |config|
    config.api_key = '  AIzaSyCg_n1cJ8_oNnZA6TBF1UXCtFblLnJ7E_M'
    config.log_level = :debug
  end

  private
  def authenticate_user!
    unless current_user
      nil
    end
  end

  def current_user
    @current_user ||= User.find_by(id: session[:current_user_id])
  end



end
