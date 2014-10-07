class Submission
  include Mongoid::Document
  include Mongoid::Timestamps

  validates :name, presence: true
  validates :body, presence: true

  has_many :downloads
  has_many :images
  
  field :name, type: String
  field :body, type: String
  field :type, type: String

  belongs_to :user

  def is_new?
    false
  end

  def is_featured?
    false
  end
end
