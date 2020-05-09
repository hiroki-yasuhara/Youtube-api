module ApiHelper
require 'google/apis/youtube_v3'
require 'active_support/all'

GOOGLE_API_KEY="AIzaSyBZEM9KGqwTKfSs3gsL5i1Us-SbDBuUhYY" 

def find_videos(keyword,row_count, after: 1.months.ago, before: Time.now)
    service = Google::Apis::YoutubeV3::YouTubeService.new
    service.key = GOOGLE_API_KEY
    next_page_token = nil
    opt = {
      q: keyword,
      type: 'video',
      max_results: row_count.to_i,
      order: :date,
    page_token: next_page_token,
    published_after: after.iso8601,
    published_before: before.iso8601
  }
    result =service.list_searches(:snippet, opt)

    result
  end
  
  def hash_video(results)
    videos = []
      results.items.each do |item|
        video_statics = videos(item.id.video_id)
        channel_statics= channels(item.snippet.channel_id)
        video_id = item.id.video_id
        title = item.snippet.title
        published_at=item.snippet.published_at
        play_count =video_statics.items.first.statistics.view_count
        channel_title =channel_statics.items.first.snippet.title
        subscriber_count =channel_statics.items.first.statistics.subscriber_count
        hash = {}
        hash["video_id"] = video_id
        hash["title"] = title
        hash["published_at"] = published_at
        hash["view_count"] = play_count
        hash["channel_title"] = channel_title
        hash["subscriber_count"] = subscriber_count
        videos << hash
      end 
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
