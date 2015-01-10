class Report
  include Mongoid::Document
  field :report_type, type: String
  field :comments, type: String
end
