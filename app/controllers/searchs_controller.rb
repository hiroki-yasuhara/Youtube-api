class SearchsController < ApplicationController
  def index
   session[:keyword]=nil
   session[:row_count]=nil
  end


  def create
    youtube_data = find_videos(params[:search][:keyword],params[:search][:row_count])
    @videos =hash_video(youtube_data)
    session[:keyword]=params[:search][:keyword]
    session[:row_count]=params[:search][:row_count]
    render :index
  end
  
  def csv
    #if session[:keyword].present? 
      youtube_data = find_videos(session[:keyword],session[:row_count])
      @videos =hash_video(youtube_data)
    #end
      render :index
  end

end
