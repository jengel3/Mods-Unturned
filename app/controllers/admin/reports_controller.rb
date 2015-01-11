class Admin::ReportsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_admin
  before_filter :set_report, only: [:show, :delete_content, :deny, :resolve, :close, :reopen]

  def index
    if params[:status] == 'active' || !params[:status]
      @reports = Report.where(:status => params[:status].titleize)
    else
      @reports = Report.ne(:status => "Active")
    end
  end

  def show
    redirect_to admin_reports_path unless @report
  end

  def delete_content
    @report.delete_content
    redirect_to admin_reports_path, :notice => "Successfully deleted the content pertaining to this report."
  end

  def deny
    @report.deny
    redirect_to admin_reports_path, :notice => "Successfully denied a report."
  end
  
  def resolve
    @report.resolve
    redirect_to admin_reports_path, :notice => "Successfully resolved a report."
  end

  def reopen
    @report.reopen
    redirect_to admin_report_path(@report), :notice => "Successfully reopened a report."
  end

  def close
    @report.close
    redirect_to admin_reports_path, :notice => "Successfully closed a report."
  end

  private
  def set_report
    @report = Report.find(params[:id] || params[:report_id])
  end
end
