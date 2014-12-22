class Video
  include Mongoid::Document
  include Mongoid::Timestamps

  validates :url, presence: true

  before_save :set_thumbnail

  field :url, type: String
  field :thumbnail, type: String

  belongs_to :submitter, class_name: 'User', :inverse_of => 'submitted_videos'
  belongs_to :submission

  def set_thumbnail
    yt_regex = /^https:\/\/www\.youtube\.com\/watch\?v=([a-zA-Z0-9_-]*)/
    video_id = yt_regex.match(self.url)
    if !video_id
      return false
    end
    video_id = video_id[1]
    self.thumbnail = "https://img.youtube.com/vi/#{video_id}/0.jpg"
  end
end
