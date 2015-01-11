class Comment
  include Mongoid::Document
  include Mongoid::Paranoia
  include Mongoid::Timestamps

  field :text, type: String
  belongs_to :submission
  belongs_to :user
  has_many :reports, :as => :reportable

  validates :text, presence: true
end
