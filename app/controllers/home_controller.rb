class HomeController < ApplicationController
  def home
    @most_popular_today = Submission.most_popular_today
    @favorites = Submission.get_favorites
    @recent = Submission.recent.limit(2)
  end
end
