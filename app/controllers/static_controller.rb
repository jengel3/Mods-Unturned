class StaticController < ApplicationController
  def index
    @assets = Submission.where(:type => "Asset")
    @levels = Submission.where(:type => "Level")
  end
end
