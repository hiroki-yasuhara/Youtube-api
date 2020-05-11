module ApiHelper
require 'google/apis/youtube_v3'
require 'active_support/all'
require 'date'

GOOGLE_API_KEY=ENV['GOOGLE_API_KEY']

def find_videos(keyword,row_count,order,publishedAfter, before: Time.now)
    service = Google::Apis::YoutubeV3::YouTubeService.new
    service.key = GOOGLE_API_KEY
    next_page_token = nil
    after = date(publishedAfter)
    opt = {
      q: keyword,
      type: 'video',
      max_results: row_count.to_i,
      order: order,
    page_token: next_page_token,
    published_after: after.iso8601,
    published_before: before.iso8601
  }
    result =service.list_searches(:snippet, opt)
    result
  end
  
  def date(publishedAfter)
    case publishedAfter
    when '1.months.ago' then
      after =1.months.ago
    when '3.months.ago' then
      after =3.months.ago
    when '6.months.ago' then
      after =6.months.ago
    when '1.years.ago' then
      after =1.years.ago
    when '3.years.ago' then
      after =3.years.ago
    else 
      after =5.years.ago
    end
    after
  end 
  
  def hash_video(results)
    videos = []
      sum =0
      results.items.each do |item|
        video_statics = videos(item.id.video_id)
        channel_statics= channels(item.snippet.channel_id)
        video_id = item.id.video_id
        title = item.snippet.title
        published_at=item.snippet.published_at
        play_count =video_statics.items.first.statistics.view_count
        channel_title =channel_statics.items.first.snippet.title
        subscriber_count =channel_statics.items.first.statistics.subscriber_count
        play_rate =(play_count.to_f/subscriber_count.to_i)*100
        if(session[:filter].nil? || session[:filter]=="" || play_rate >= (session[:filter].to_i))
          hash = {}
          hash["video_id"] = video_id
          hash["title"] = title
          hash["published_at"] = published_at.to_date
          hash["view_count"] = play_count
          hash["channel_title"] = channel_title
          hash["subscriber_count"] = subscriber_count
          hash["play_rate"] = play_rate.round(3)
          videos << hash
          sum =sum+1
        end
      end 
      session[:cont]=sum
      videos
  end
  
  def videos(video_ids)
    service = Google::Apis::YoutubeV3::YouTubeService.new
    service.key = GOOGLE_API_KEY
     opt = {
       id: video_ids
     }
    videos = service.list_videos(:statistics, opt)
  end
  
  def channels(channel_ids)
    service = Google::Apis::YoutubeV3::YouTubeService.new
    service.key = GOOGLE_API_KEY
     opt = {
       id: channel_ids
     }
    channels = service.list_channels("statistics,snippet", opt)
  end

end
