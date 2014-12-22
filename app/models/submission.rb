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
  has_many :videos, :dependent => :destroy
  
  field :name, type: String
  field :body, type: String
  field :type, type: String
  field :old_downloads, type: Integer
  field :last_update, type: Time, default: nil
  field :approved_at, type: Time, default: nil
  field :last_favorited, type: Time, default: nil
  field :total_downloads, type: Integer, default: 0

  belongs_to :user
  has_many :comments, :dependent => :destroy

  scope :recent, -> { where(:approved_at.exists => true).desc(:last_update) }
  scope :valid, -> { where(:approved_at.exists => true) }

  slug :name

  class << self

    def most_popular_today
      key = "STAT:most_popular_today"
      result = REDIS.get(key)
      if !result
        result = Array.new
        sort = { "$sort" => { count: -1 } }
        limit = {"$limit" => 1}
        group = { "$group" =>
          { "_id" => "$submission_id", "count" => { "$sum" => 1 } }
        }
        result = Download.daily.collection.aggregate([group, sort, limit])[0]['_id']
        REDIS.set(key, result)
        REDIS.expire(key, 1.hour)
      end
      return Submission.find(result)
    end


    def get_favorites
      return where(:last_favorited.exists => true).desc(:last_favorited).limit(4)
    end
  end

  def get_cached_image
    key = "IMAGE:#{id}"
    result = REDIS.get(key)
    if !result
      result = main_image
      if result
        result = result.image_url
        REDIS.set(key, result)
        REDIS.expire(key, 24.hours)
      else
        return nil
      end
    end
    result
  end

  def get_username
    key = "CREATOR:#{id}"
    result = REDIS.get(key)
    if !result
      result = user.username
      REDIS.set(key, result)
      REDIS.expire(key, 24.hours)
    end
    result
  end

  def desc
    if body.length > 75
      return body[0..75].gsub('\n', ' ') + "..."
    else
      return body.gsub('\n', ' ')
    end
  end

  def download_count
    key = "DOWNLOADS:#{name.gsub(' ', '_')}"
    dloads = REDIS.get(key)
    if !dloads
      dloads = total_downloads
      REDIS.set(key, dloads)
      REDIS.expire(key, 6.hours + rand(1..30).minutes)
    end
    return dloads.to_i
  end

  def add_download(ip, downloader, upload)
    self.downloads.create(:ip => ip, :user => downloader, :upload => upload, creator: user).save!
    key = "DOWNLOADS:#{name.gsub(' ', '_')}"
    if REDIS.get(key)
      REDIS.incr(key)
    else
      download_count
    end
  end

  def is_new?
    Time.now - 24.hour < created_at
  end

  def is_updated?
    last_update && Time.now - 24.hour < last_update
  end

  def latest_download
    uploads.where(:approved => true).desc(:created_at).first
  end

  def main_image
    images.where(:location => "Main").first
  end

  def thumbnails
    result = images.where(:location.ne => "Main").limit(6)
  end

  def can_show?
    main_image && latest_download
  end

  def ready?
    approved_at != nil
  end
end
