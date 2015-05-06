class Admin::ReportsController < Admin::BaseController
  before_filter :set_report, only: [:show, :delete_content, :deny, :resolve, :close, :reopen]

  def index
    if !params[:status] || params[:status] == 'active'
      @reports = Report.where(:status => 'Active')
    elsif params[:status] == "closed"
      @reports = Report.ne(:status => "Active")
    elsif params[:status]
      @reports = Report.where(:status => params[:status].titleize)
    end
  end

  def show
    redirect_to admin_reports_path unless @report
  end

  def delete_content
    @report.delete_content(current_user)
    redirect_to admin_reports_path, :notice => t('admin.reports.successfully_deleted_content')
  end

  def deny
    @report.deny(current_user)
    redirect_to admin_reports_path, :notice => t('admin.reports.successfully_denied')
  end
  
  def resolve
    @report.resolve(current_user)
    redirect_to admin_reports_path, :notice => t('admin.reports.successfully_resolved')
  end

  def reopen
    @report.reopen(current_user)
    redirect_to admin_report_path(@report), :notice => t('admin.reports.successfully_reopened')
  end

  def close
    @report.close(current_user)
    redirect_to admin_reports_path, :notice => t('admin.reports.successfully_closed')
  end

  private
  def set_report
    @report = Report.find(params[:id] || params[:report_id])
  end
end
