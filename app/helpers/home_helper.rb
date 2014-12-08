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
      records.each { |r| result << {submission: r['_id'].to_s, downloads: r['count']} }
      result = result.to_json
      REDIS.set(key, result)
      REDIS.expire(key, 12.hours)
    end
    json = JSON.parse(result)
    submissions = json.map { |x| x['submission'] }
    order = {}
    submissions.each_with_index { |s, i| order[s] = i}
    return Submission.find(submissions).sort_by { |sub| order[sub.id.to_s] }
  end

  def get_top_developers
    key = "STAT:top_weekly_developers"
    result = REDIS.get(key)
    if !result
      puts "PINING REDIS"
      result = Array.new
      sort = { "$sort" => { count: -1 } }
      limit = {"$limit" => 5}
      group = { "$group" =>
        { "_id" => "$creator_id", "count" => { "$sum" => 1 } }
      }
      records = Download.weekly.collection.aggregate([group, sort, limit])
      records.each { |r| result << {user: r['_id'].to_s, downloads: r['count']} }
      result = result.to_json
      REDIS.set(key, result)
      REDIS.expire(key, 36.hours)
    end
    json = JSON.parse(result)
    users = json.map { |x| x['user'] }
    order = {}
    users.each_with_index { |s, i| order[s] = i}
    return User.find(users).sort_by { |user| order[user.id.to_s] }
  end
end
