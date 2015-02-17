class Download
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include GlobalID::Identification

  field :ip, type: String
  field :real, type: String

  after_create :cache_downloads

  belongs_to :upload
  belongs_to :user, class_name: 'User', inverse_of: :user # Possibly null if user is not logged in.
  belongs_to :submission
  belongs_to :creator, class_name: 'User', inverse_of: :owned_downloads

  validates :ip, presence: true
  validates :upload_id, presence: true

  scope :daily, -> { where(:created_at.gte => Date.today - 24.hours) }
  scope :weekly, -> { where(:created_at.gte => Date.today - 1.week) }

  index({ created_at: 1 }, { unique: false, name: "download_timestamp", background: true })

  def cache_downloads
    if real
      submission.total_downloads += 1
      submission.save
    end
  end
end
