class ReportsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @reportable = find_reportable
    @report = @reportable.reports.build(report_params)
    @report.reporter = current_user
    if @report.save
      redirect_to @reportable, :notice => t('reports.successfully_reported')
    else
      redirect_to @reportable, :alert => t('reports.unable_to_report')
    end
  end

  private
  def report_params
    params.require(:report).permit(:report_type, :comments)
  end

  def find_reportable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end
end
