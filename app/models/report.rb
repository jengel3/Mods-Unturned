class Report
  include Mongoid::Document
  include Mongoid::Timestamps

  before_save :set_resolved
  
  validates :report_type, presence: true, inclusion: { in: ['Spam', 'Inappropriate', 'Not Original', 'Other'], message: "Invalid report type."}
  validates :status, inclusion: { in: ['Active', 'Retracted', 'Content Deleted', 'Resolved'] }

  def set_resolved
    self.resolved_at = Time.now
  end

  field :report_type, type: String, default: 'Spam'
  field :comments, type: String
  field :status, type: String, default: 'Active'
  field :resolved_at, type: Time

  belongs_to :resolver, class_name: 'User' # report resolver
  belongs_to :user, class_name: 'User' # report creator

  belongs_to :reportable, polymorphic: true

  def delete_content
    reportable.destroy!
  end

  def resolve
    self.status = 'Resolved'
    self.save
  end

  def retract
    self.status = 'Retracted'
  end
end
