class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  # sscope 
  # default_scope { where(:deleted_at.exists => false).asc(:created_at) }

  before_destroy :mark_deleted

  def mark_deleted
    self.deleted_at = Time.now
    self.save!
    false
  end

  field :text, type: String
  field :deleted_at, type: String
  belongs_to :submission
  belongs_to :user

  validates :text, presence: true
end
