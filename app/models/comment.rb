class Comment
  include Mongoid::Document
  field :text, type: String
  belongs_to :submission
  belongs_to :user
end
