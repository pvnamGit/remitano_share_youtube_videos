require 'youtube-dl'

class VideoShareController < ApplicationController
  before_action :authenticate_user!, :except => [:index]

  def index
    videos = VideoShare.all
    videos
  end

  def create
    is_video_existed = VideoShare.find_by(url: params[:url], user_id: @current_user.id)
    if (is_video_existed)
      return flash[:error] = "You have already shared this video"
    end
    binding.pry
    video_info = Yt::Video.new(params[:url])

    title = video_info['title']
    description = video_info['description']
    video = VideoShare.new(url: params[:url], title: title, description: description)
    if (video.save)
      flash[:notice] = "Success"
      video
    end

    flash[:error] = "Failed"
  end
end
