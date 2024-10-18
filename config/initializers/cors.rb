# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'
    resource '/api/*',
      methods: :any,
      headers: :any,
      expose: '*',
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
