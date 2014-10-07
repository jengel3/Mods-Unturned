class Download
  include Mongoid::Document
  include Mongoid::Timestamps
  
  mount_uploader :download, DownloadUploader
  belongs_to :submission

  field :downloads, type: Integer
  field :game_version, type: String
  field :version, type: String
  field :changelog, type: String
  field :notes, type: String
  field :type, type: String
end
