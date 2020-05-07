class SearchsController < ApplicationController
  def index
   # if params[:session][:keyword].present?
   #   @youtube_data = find_videos(params[:session][:keyword])
   # end
   #@youtube_data = find_videos("キングダム")
   session[:keyword]=nil
   session[:row_count]=nil
  end

  def show
  end

  def new
  end

  def create
    @youtube_data = find_videos(params[:search][:keyword],params[:search][:row_count])
    session[:keyword]=params[:search][:keyword]
    session[:row_count]=params[:search][:row_count]
    render :index
  end
  
  def csv
    if session[:keyword].present? 
      @youtube_data = find_videos(session[:keyword],session[:row_count])
    end
      render :index
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
