class Submission
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  validates :name, presence: true, uniqueness: true
  validates :body, presence: true
  validates :type, presence: true, inclusion: { in: %w(Level Asset), message: "Invalid submission type." }

  has_many :uploads, :dependent => :destroy
  has_many :downloads, :dependent => :destroy
  has_many :images, :dependent => :destroy
  
  field :name, type: String
  field :body, type: String
  field :type, type: String
  field :last_update, type: Time, default: nil
  field :approved_at, type: Time, default: nil

  belongs_to :user
  has_many :comments, :dependent => :destroy

  slug :name

  class << self
    def most_popular_today
      key = "most_popular_today"
      result = REDIS.get(key)
      if !result
        highest = 0
        result = Download.daily.desc(:upload).first.submission
        REDIS.set(key, result.id)
        REDIS.expire(result.id, 1.hours)
      else
        result = Submission.find(result)
      end
      result
    end
  end

  def download_count
    key = "#{name}_downloads"
    dloads = REDIS.get(key)
    if !dloads
      dloads = downloads.count
      REDIS.set(key, dloads)
      REDIS.expire(key, 2.hours)
    end
    dloads
  end

  def add_download(ip, downloader, upload)
    self.downloads.create(:ip => ip, :user_id => downloader.id, :upload => upload).save!
    REDIS.incr("#{name}_downloads")
  end

  def is_new?
    Time.now - 24.hour < created_at
  end

  #TODO Decide what makes submissions featured.
  def is_featured?
    false
  end

  def is_updated?
    last_update && Time.now - 24.hour < last_update
  end

  def latest_download
    uploads.where(:approved => true).desc(:created_at).first
  end

  def main_image
    images.where(:location => "Main").desc(:created_at).first
  end

  def thumbnails
    images.where(:location => /Thumbnail./).desc(:created_at).limit(6)
  end

  def ready?
    latest_download and main_image
  end
end
