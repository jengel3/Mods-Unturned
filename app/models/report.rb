class Report
  include Mongoid::Document
  include Mongoid::Timestamps
  
  validates :report_type, presence: true, inclusion: { in: ['Spam', 'Inappropriate', 'Not Original', 'Other'], message: "Invalid report type."}

  field :report_type, type: String
  field :comments, type: String

  belongs_to :reportable, polymorphic: true
end
