class Image
  include Mongoid::Document

  before_create :delete_old
  after_save :check_approval
  after_save :refresh_cache

  mount_uploader :image, ImageUploader

  validates :location, presence: true, inclusion: { in: ['Main', 'Thumbnail1', 'Thumbnail2', 'Thumbnail3', 'Thumbnail4', 'Thumbnail5', 'Thumbnail6']}
  validates :image, presence: true

  belongs_to :submission
  field :location, type: String

  index({ location: 1 }, { unique: false, name: "image_loc_index", background: true })

  def num
    location[ -1..-1 ].to_i
  end

  private
  def delete_old
    submission.images.where(:location => self.location).where(:id.ne => self.id).destroy_all
  end

  def refresh_cache
    key = "IMAGE:#{submission.id}"
    REDIS.del(key)
  end

  def check_approval
    if !(location != "Main" || submission.approved_at) && submission.can_show?
      submission.approved_at = Time.now
      submission.save
    end
  end
end
