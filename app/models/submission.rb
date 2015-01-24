class Submission
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Timestamps
  include Mongoid::Elasticsearch
  elasticsearch!
  
  @@milestones = [50, 100, 500, 1000, 2500, 5000, 10000, 20000, 30000, 40000, 50000, 60000]

  validates :name, presence: true, uniqueness: true, length: { :minimum => 3, :maximum => 30 }
  validates :body, presence: true
  validates :type, presence: true, inclusion: { in: %w(Level Asset), message: "Invalid submission type." }

  has_many :uploads, :dependent => :destroy
  has_many :downloads, :dependent => :destroy
  has_many :images, :dependent => :destroy
  has_many :videos, :dependent => :destroy
  
  field :name, type: String
  field :body, type: String
  field :type, type: String
  field :last_update, type: Time, default: nil
  field :approved_at, type: Time, default: nil
  field :last_favorited, type: Time, default: nil
  field :total_downloads, type: Integer, default: 0

  belongs_to :user
  has_many :comments, :dependent => :destroy
  has_many :reports, :as => :reportable

  scope :recent, -> { where(:approved_at.exists => true).desc(:last_update) }
  scope :valid, -> { where(:approved_at.exists => true) }
  scope :popular, -> { desc(:total_downloads) }

  slug :name, history: true

  class << self

    def assets
      where(:type => "Asset")
    end

    def levels
      where(:type => "Level")
    end

    def popular
      desc(:total_downloads)
    end

    def slider
      key = "STAT:slider"
      result = REDIS.get(key)
      if !result
        new_popular = Submission.valid.where(:approved_at.gte => Date.today - 24.hours).where(:total_downloads.gte => 20).limit(2)
        veteran = Submission.valid.where(:approved_at.lt => Date.today - 48.hours).where(:total_downloads.gte => 250).limit(2)
        randoms = Submission.valid.in(id: Submission.distinct(:id).sample(2))
        result = Submission.or(veteran.selector, randoms.selector, new_popular.selector)
        result = result.to_json(:only => [:name], :methods => [:cached_image, :slug])
        REDIS.set(key, result)
        REDIS.expire(key, 12.hours)
      end
      return JSON.parse(result)
    end

    def favorites
      return where(:last_favorited.exists => true).desc(:last_favorited).limit(4)
    end
  end

  def cached_image
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
    count = 0
    if REDIS.get(key)
      count = REDIS.incr(key)
    else
      count = download_count
    end
    if @@milestons.include?(count)
      UserMailer.milestone(self, count)
    end
  end

  def is_new?
    return false
    Time.now - 24.hour < created_at
  end

  def is_updated?
    return false
    last_update && Time.now - 24.hour < last_update
  end

  def latest_download
    uploads.where(:approved => true).desc(:created_at).first
  end

  def main_image
    images.where(:location => "Main").first
  end

  def thumbnails
    images.where(:location.ne => "Main").limit(6)
  end

  def can_show?
    main_image && latest_download
  end

  def ready?
    approved_at != nil
  end
end
