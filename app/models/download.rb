class Download
  include Mongoid::Document
  include Mongoid::Timestamps

  field :ip, type: String

  belongs_to :upload
  belongs_to :user # Possibly null if user is not logged in.

  validates :ip, presence: true
  validates :upload_id, presence: true

end
