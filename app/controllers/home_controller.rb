class HomeController < ApplicationController
  include HomeHelper
  def home
    @most_popular_today = Submission.most_popular_today
    @favorites = Submission.get_favorites
    @recent = Submission.recent.limit(2)
    puts "HERE", @recent
    @recent = @recent.any? ? @recent : []
    @weekly_submissions = get_top_submissions
    @weekly_developers = get_top_developers
  end
end
