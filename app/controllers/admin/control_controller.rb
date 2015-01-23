class Admin::ControlController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_admin
  def index
  end
end
