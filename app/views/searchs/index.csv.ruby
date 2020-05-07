require 'csv'
if @youtube_data.present?
CSV.generate do |csv|
  column_names = %w(タイトル 投稿日時 再生数 登録者数 URL)
  csv << column_names
  @youtube_data.items.each do |data|
  #snippet = data.snippet
  snippet = data.snippet
    csv_column_values = [
      snippet.title,
      snippet.published_at,
      snippet.channel_title
    ]
    csv << csv_column_values
  end
end
end