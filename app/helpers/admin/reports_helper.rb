module Admin::ReportsHelper
  def report_content(report)
    return nil if !report.reportable
    if report.reportable_type == 'Comment'
      return report.reportable.text
    elsif report.reportable_type == 'Submission'
      return report.reportable.name
    end
  end
end
