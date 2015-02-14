class Upload
  include Mongoid::Document
  include Mongoid::Timestamps

  before_save :set_update
  after_save :check_approval
  
  mount_uploader :upload, UploadUploader

  validates :name, presence: true
  validates :version, presence: true
  validates :upload, presence: true
  validate :verify_structure

  field :name, type: String
  field :version, type: String
  field :approved, type: Boolean, default: false
  field :denied, type: Boolean, default: false

  has_many :downloads, :dependent => :destroy
  belongs_to :submission

  def verify_structure
    valid = false
    if submission.type == 'Level'
      Zip::File.open(upload.path) do |zipfile| 
        zipfile.each do |entry|
          if entry.name == 'Level.dat'
            valid = true
          end
        end
      end
    end
    unless valid
      errors[:base] << "The files included in this ZIP are structured incorrectly. Please see the tips."
    end
  end

  private
  def check_approval
    if !approved || submission.approved_at
      return
    elsif submission.can_show?
      submission.approved_at = Time.now
      submission.save
    end
  end

  def set_update
    if not approved
      return
    end
    self.submission.last_update = Time.now
    self.submission.save
  end
end
