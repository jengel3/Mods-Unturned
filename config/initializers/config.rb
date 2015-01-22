REDIS_PREFIX = 'UNTURNED:'
MAINTENANCE = false
if ENV["REDISCLOUD_URL"]
    REDIS = Redis.new(:url => ENV["REDISCLOUD_URL"])
else
  REDIS = Redis.new(:host => "127.0.0.1")
end
if ENV['BONSAI_URL']
  Mongoid::Elasticsearch.client_options = {hosts: [ENV['BONSAI_URL']]}
end