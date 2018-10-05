Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'
    resource '/api/*',
      methods: :any,
      headers: 'Origin, X-Requested-With, Content-Type, Accept, Authorization',
      expose: 'X-Filename'
  end
end
