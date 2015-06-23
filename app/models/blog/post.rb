class Blog::Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  field :title, type: String
  field :body, type: String
  field :baked_body, type: String

  validates :title, presence: true
  validates :body, presence: true
  validates :baked_body, presence: true

  belongs_to :author, class_name: 'User', inverse_of: 'blog_posts'

  before_validation :bake_body

  slug :title, history: true

  def bake_body
  	self.baked_body = body.bbcode_to_html.gsub(/[\r\n]+/, "<br>")
  end
end
