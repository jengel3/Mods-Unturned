class Image
  include Mongoid::Document

  before_create :delete_old
  after_create :check_approval

  mount_uploader :image, ImageUploader

  belongs_to :submission
  field :location, type: String

  index({ location: 1 }, { unique: false, name: "image_loc_index", background: true })

  private
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
