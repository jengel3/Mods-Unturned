module HomeHelper
  def get_top_submissions
    key = "top_weekly_submissions"
    result = REDIS.get(key)
    if !result
      result = Array.new
      Download.weekly.desc(:created_at).distinct(:submission_id)[0..4].each { |r| result << r.to_s}
      REDIS.set(key, result.to_json)
      REDIS.expire(key, 12.hours)
      return Submission.find(result)
    end
    return Submission.find(JSON.parse(result))
  end

  def get_top_developers
    key = "top_weekly_developers"
    result = REDIS.get(key)
    if !result
      result = User.all.desc(:total_downloads).limit(5)
      usernames = Array.new
      result.distinct(:username).each { |u| usernames << u }
      REDIS.set(key, usernames.to_json)
      REDIS.expire(key, 24.hours)
      return usernames
    end
    return JSON.parse(result)
  end
end
