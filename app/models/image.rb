class Image
  include Mongoid::Document
  
  belongs_to :submission
  mount_uploader :image, ImageUploader

  field :location, type: String
end
