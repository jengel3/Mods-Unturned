class Submission
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  validates :name, presence: true, uniqueness: true
  validates :body, presence: true
  validates :type, presence: true, inclusion: { in: %w(Level Asset), message: "Invalid submission type." }

  has_many :downloads, :dependent => :destroy
  has_many :images, :dependent => :destroy
  
  field :name, type: String
  field :body, type: String
  field :type, type: String

  belongs_to :user

  slug :name

  def is_new?
    Time.now - 24.hour < created_at
  end

  def is_featured?
    false
  end

  def latest_download
    downloads.where(:approved => true).desc(:created_at).first
  end

  def main_image
    images.where(:location => "Main").first
  end

  def thumbnails
    images.where(:location => /Thumbnail./).limit(6)
  end
end
