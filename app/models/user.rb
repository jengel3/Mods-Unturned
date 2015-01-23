class User
  include Mongoid::Document
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable

  validates :username, presence: true, uniqueness: true, :length => { :maximum => 16 } # Max username length is 16
  validates :email, presence: true, uniqueness: true

  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""
  field :username, type: String, default: ""

  field :admin, type: Boolean, default: false

  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  field :remember_created_at, type: Time

  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  field :accepts_emails, type: Boolean, default: true

  has_many :submissions, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :downloads, class_name: 'Download', inverse_of: :user
  has_many :owned_downloads, inverse_of: :creator, class_name: 'Download'
  has_many :submitted_videos, :inverse_of => :submitter, class_name: 'Video'
  has_many :created_reports, :inverse_of => :creator, class_name: 'Report', foreign_key: 'reporter_id'
  has_many :resolved_reports, :inverse_of => :resolver, class_name: 'Report', foreign_key: 'resolver_id' 
end
