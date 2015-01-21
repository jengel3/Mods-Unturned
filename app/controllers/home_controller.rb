class HomeController < ApplicationController
  include HomeHelper
  def home
    @slider = Submission.slider
    @favorites = Submission.favorites
    @recent = Submission.recent.limit(2)
    @recent = @recent.any? ? @recent : []
    @weekly_submissions = get_top_submissions
    @weekly_developers = get_top_developers
  end

  def about
  end
end
