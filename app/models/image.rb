class Image
  include Mongoid::Document

  after_create :check_approval

  belongs_to :submission
  mount_uploader :image, ImageUploader

  before_create :delete_old

  field :location, type: String

  def delete_old
    if old = submission.images.where(:location => self.location).first
      old.destroy
    end
  end

  def check_approval
    if location != "Main" || submission.approved_at
      return
    end
    if submission.ready?
      submission.approved_at = Time.now
      submission.save
    end
  end
end
