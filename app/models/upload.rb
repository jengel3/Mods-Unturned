class Upload
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include GlobalID::Identification

  before_save :set_update
  after_save :check_approval
  
  mount_uploader :upload, UploadUploader

  validates :name, presence: true
  validates :version, presence: true
  validates :upload, presence: true

  field :name, type: String
  field :version, type: String
  field :approved, type: Boolean, default: false
  field :denied, type: Boolean, default: false

  has_many :downloads, :dependent => :destroy
  belongs_to :submission

  private
  def check_approval
    if !(approved && submission.approved_at) && submission.can_show?
      submission.approved_at = Time.now
      submission.save
    end
  end

  def set_update
    return if !approved
    self.submission.last_update = Time.now
    self.submission.save
  end
end
