if Rails.env.production?
  uri = URI.parse(ENV['REDIS_URL'])
  Rack::MiniProfiler.config.storage_options = { host: uri.host, port: uri.port, password: uri.password }
  Rack::MiniProfiler.config.storage = Rack::MiniProfiler::RedisStore
end
