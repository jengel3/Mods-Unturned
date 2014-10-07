class StaticController < ApplicationController
  def index
    @assets = Submission.where(:type => "asset")
    @levels = Submission.where(:type => "level")
  end
end
