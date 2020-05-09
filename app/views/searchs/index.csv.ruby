require 'csv'
if @videos.present?
CSV.generate do |csv|
  column_names = %w(ID タイトル 投稿日時 再生数 チャンネル チャンネル数)
  csv << column_names
  @videos.each do |video|
    csv_column_values = [
      video["video_id"],
      video["title"],
      video["published_at"],
      video["view_count"],
      video["channel_title"],
      video["subscriber_count"]
    ]
    csv << csv_column_values
  end
end
end