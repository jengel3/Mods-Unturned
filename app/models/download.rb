class Download
  include Mongoid::Document
  include Mongoid::Timestamps
  
  mount_uploader :download, DownloadUploader
  belongs_to :submission

  validates :name, presence: true
  validates :game_version, presence: true
  validates :version, presence: true
  validates :type, presence: true
  validates :download, presence: true

  field :name, type: String
  field :downloads, type: Integer, default: 0
  field :game_version, type: String
  field :version, type: String
  field :changelog, type: String
  field :notes, type: String
  field :type, type: String, default: "Release"
  field :approved, type: Boolean, default: false
  field :denied, type: Boolean, default: false
end
