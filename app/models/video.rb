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
    # NYI
  end
end
