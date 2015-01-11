class Report
  include Mongoid::Document
  include Mongoid::Timestamps

  before_save :set_resolved
  
  validates :report_type, presence: true, inclusion: { in: ['Spam', 'Inappropriate', 'Not Original', 'Other'], message: "Invalid report type."}
  validates :status, inclusion: { in: ['Active', 'Denied', 'Content Deleted', 'Resolved', 'Closed'] }

  def set_resolved
    self.resolved_at = Time.now unless !self.resolved_at
  end

  field :report_type, type: String, default: 'Spam'
  field :comments, type: String
  field :status, type: String, default: 'Active'
  field :resolved_at, type: Time

  belongs_to :resolver, class_name: 'User', inverse_of: :created_reports# report resolver
  belongs_to :reporter, class_name: 'User', inverse_of: :resolved_reports # report creator

  belongs_to :reportable, polymorphic: true

  def delete_content
    reportable.destroy!
    self.status = 'Content Deleted'
    self.save
  end

  def resolve
    self.status = 'Resolved'
    self.save
  end

  def close
    self.status = 'Closed'
    self.save
  end

  def reopen
    self.status = 'Active'
    self.resolved_at = nil
    self.save
  end

  def deny
    self.status = 'Denied'
    self.save
  end
end
