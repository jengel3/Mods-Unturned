class HomeController < ApplicationController
  def home
    @most_popular_today = Submission.most_popular_today
  end
end
