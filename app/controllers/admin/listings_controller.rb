include ActionView::Helpers::TextHelper
class Admin::ListingsController < ApplicationController
  def users
    @users = User.all
    @users = @users.order_by(sort_users(params[:sort] ||= ''))
    @users = @users.page(params[:page]).per(20)
  end

  def moderate
    if !params[:type] || params[:type].blank?
      flash[:alert] = "Please specify a class."
      return redirect_to :back
    end
    object = params[:type].singularize.classify.constantize
    count = params[:objects].count ||= 0
    failed = 0
    params[:objects].each do |k, v|
      o = object.find(k)
      o ? o.destroy : failed += 1
    end
    flash[:notice] = "Successfully deleted #{pluralize(count, params[:type].downcase)}."
    if failed > 0
      flash[:notice] += " #{failed} failed."
    end
    redirect_to :back
  end

  private
  def sort_users(sort)
    case sort.downcase
    when "username"
      "username ASC"
    when "-username"
      "username DESC"
    when "email"
      "email ASC"
    when "-email"
      "email DESC"
    when "sign_in_count"
      "sign_in_count ASC"
    when "-sign_in_count"
      "sign_in_count DESC"
    else
      "username ASC"
    end
  end
end
