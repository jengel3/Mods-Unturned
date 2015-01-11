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

  belongs_to :resolver, class_name: 'User', inverse_of: :created_reports # report resolver
  belongs_to :reporter, class_name: 'User', inverse_of: :resolved_reports # report creator

  belongs_to :reportable, polymorphic: true

  def delete_content(completed_by)
    self.status = 'Content Deleted'
    self.resolver = completed_by
    reportable.destroy
    self.save
  end

  def resolve(completed_by)
    self.status = 'Resolved'
    self.resolver = completed_by
    self.save
  end

  def close(completed_by)
    self.status = 'Closed'
    self.resolver = completed_by
    self.save
  end

  def reopen(completed_by)
    self.status = 'Active'
    self.resolved_at = nil
    self.resolver = nil
    self.save
  end

  def deny(completed_by)
    self.status = 'Denied'
    self.resolver = completed_by
    self.save
  end
end
