class ReportsController < ApplicationController
  before_filter :authenticate_user

  def create
    @reportable = find_reportable
    @report = @reportable.reports.build(report_params)
    if @report.save
      current_user.reports << @report
      redirect_to @reportable, :notice => "Successfully reported content."
    else
      redirect_to @reportable, :alert => "Unable to report content."
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
