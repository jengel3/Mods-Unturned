class Image
  include Mongoid::Document
  
  belongs_to :submission
  mount_uploader :image, ImageUploader
end
