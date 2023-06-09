class VideoShareController < ApplicationController
  before_action :authenticate_user!, :only => [:create, :my_videos, :destroy]

  def index
    @videos = VideoShare.all.order(created_at: :desc)
  end

  def new
    if current_user.nil?
      redirect_to root_path
    end
    flash[:alert] = nil
    flash[:notice] = nil
  end

  def create
    if current_user.nil?
      flash[:alert] = "You need to sign in or sign up before continuing."
      return
    end
    is_video_existed = VideoShare.find_by(url: params[:url], user_id: current_user.id)
    if is_video_existed
      flash[:alert] = "You have already shared this video"
      return render :new
    end
    unless valid_youtube_url?(params[:url])
      flash[:alert] = "Invalid URL"
      return render :new
    end
    video_info = Yt::Video.new url: params[:url]
    title = video_info.title
    description = video_info.description
    thumbnail_url = video_info.thumbnail_url
    video = current_user.video_shares.new(url: params[:url], title: title, description: description, thumbnail_url: thumbnail_url)
    if video.save
      redirect_to root_path
    else
      flash[:alert] = "Fail to share video"
      render :new
    end
  end

  def my_videos
    @my_videos = current_user.video_shares.all.order(created_at: :desc)
  end

  def destroy
    @share = current_user.video_shares.find(params[:id])
    @share.destroy
    redirect_to root_path
  end

  private
  def valid_youtube_url?(url)
    url =~ %r{\A(https?://)?(www\.)?(youtube\.com/watch\?v=|youtu\.be/)[a-zA-Z0-9_-]{11}}
  end
end
