module HomeHelper
  def get_top_submissions
    key = "STAT:top_weekly_submissions"
    result = REDIS.get(key)
    if !result
      result = Array.new
      sort = { "$sort" => { count: -1 } }
      limit = {"$limit" => 5}
      group = { "$group" =>
        { "_id" => "$submission_id", "count" => { "$sum" => 1 } }
      }
      records = Download.weekly.collection.aggregate([group, sort, limit])
      puts records
      records.each { |r| result << {submission: r['_id'].to_s, downloads: r['count']} }
      REDIS.set(key, result.to_json)
      REDIS.expire(key, 12.hours)
      return Submission.find(result)
    end
    json = JSON.parse(result)
    submissions = json.map { |x| x['submission'] }
    puts submissions
    order = {}
    submissions.each_with_index { |s, i| order[s] = i}
    returned = Submission.find(submissions).sort_by { |sub| order[sub.id.to_s] }
    return returned
  end

  def get_top_developers
    key = "STAT:top_weekly_developers"
    result = REDIS.get(key)
    if !result
      result = User.all.desc(:total_downloads).limit(5)
      usernames = Array.new
      result.distinct(:username)[0..4].each { |u| usernames << u }
      REDIS.set(key, usernames.to_json)
      REDIS.expire(key, 24.hours)
      return usernames
    end
    return JSON.parse(result)
  end
end
