class StaticController < ApplicationController
  def index
    @assets = Submission.where(:type => "Asset").desc(:created_at)
    @levels = Submission.where(:type => "Level").desc(:created_at)
  end
end
