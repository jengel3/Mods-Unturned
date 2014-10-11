class Image
  include Mongoid::Document

  belongs_to :submission
  mount_uploader :image, ImageUploader

  before_create :delete_old

  field :location, type: String

  def delete_old
    if old = submission.images.where(:location => self.location).first
      old.destroy
    end
  end
end
