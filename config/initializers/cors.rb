Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'
    resource '/api/*',
      methods: :any,
      headers: 'Origin, X-Requested-With, Content-Type, Accept, Authorization',
      expose: 'X-Filename',
      if: Proc.new { |env|
        req = Rack::Request.new(env)

        if /\A\/api\/v3\/runs\/\w+\z/.match?(req.path) && req.delete?
          false
        elsif /\A\/api\/v3\/runs\/\w+\/disown\z/.match?(req.path) && req.post?
          false
        elsif /\A\/api\/v4\/runs\/\w+\z/.match?(req.path) && req.put?
          false
        else
          true
        end
      }
  end
end
