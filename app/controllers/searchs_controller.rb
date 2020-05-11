class SearchsController < ApplicationController
  def index
   if params[:param_page].present?
     session[:filter]=params[:search][:filter]
     youtube_data = find_videos(params[:search][:keyword],params[:search][:row_count],params[:search][:order],params[:search][:publishedAfter])
     @videos =Kaminari.paginate_array(hash_video(youtube_data)).page(params[:page]).per(10)
   else
   session[:keyword]=nil
   session[:row_count]=nil
   session[:order]=nil
   session[:publishedAfter]=nil
   session[:filter]=nil
   session[:cont]=nil
   session[:video_hidden]=nil
 end
  end


  def create
    if params[:search][:row_count]=="" || params[:search][:keyword]==""
      flash[:danger] = 'キーワード及び検索件数を入力してください'
    else
      session[:filter]=params[:search][:filter]
      youtube_data = find_videos(params[:search][:keyword],params[:search][:row_count],params[:search][:order],params[:search][:publishedAfter])
      @videos =Kaminari.paginate_array(hash_video(youtube_data)).page(params[:page]).per(10)
    end
      session[:keyword]=params[:search][:keyword]
      session[:row_count]=params[:search][:row_count]
      session[:order]=params[:search][:order]
      session[:publishedAfter]=params[:search][:publishedAfter]
      if params[:search][:video_hidden]=='1'
        session[:video_hidden]=true
      else
        session[:video_hidden]=false
      end
    render :index
  end
  
  def csv
    if session[:row_count].present? || session[:keyword].present? || session[:row_count]!="" || session[:keyword]!=""
      youtube_data = find_videos(session[:keyword],session[:row_count],session[:order],session[:publishedAfter])
      @videos =hash_video(youtube_data)
    end
      render :index
  end

end
