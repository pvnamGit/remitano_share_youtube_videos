class VideoShareController < ApplicationController
  before_action :authenticate_user!, :only => [:create]

  def index
    VideoShare.all
  end

  def create
    if current_user.nil?
      flash[:error] = "You must be logged in to share a video."
      return
    end
    is_video_existed = VideoShare.find_by(url: params[:url], user_id: current_user.id)
    if is_video_existed
      return flash[:error] = "You have already shared this video"
    end
    unless valid_youtube_url?(params[:url])
      return ("Invalid URL")
    end
    video_info = Yt::Video.new url: params[:url]
    title = video_info.title
    description = video_info.description
    video = current_user.video_shares.new(url: params[:url], title: title, description: description)
    if video.save
      return flash[:notice] = "Success"
    end
    flash[:error] = "Fail to share video"
  end

  private
  def valid_youtube_url?(url)
    url =~ %r{\A(https?://)?(www\.)?(youtube\.com/watch\?v=|youtu\.be/)[a-zA-Z0-9_-]{11}}
  end
end
