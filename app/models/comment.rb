class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :text, type: String
  belongs_to :submission
  belongs_to :user

  validates :text, presence: true
end
