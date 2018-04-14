source 'https://rubygems.org'
ruby '2.4.2'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

group :test, :development do
  gem 'pry-rails'
end

group :test do
  # tests
  gem 'factory_bot_rails', require: false
  gem 'json-schema'
  gem 'json-schema-rspec'
  gem 'rails-controller-testing'
  gem 'rspec-rails', require: false
  gem 'simplecov', require: false
end

group :development, :hot do
  # debugging
  gem 'meta_request'

  # errors+logging
  gem 'better_errors'
  gem 'binding_of_caller'

  # file watcher
  gem 'listen'

  # pretty things
  gem 'rails-erd', require: false
  gem 'rubocop', require: false

  # tests
  gem 'guard', require: false
  gem 'guard-rspec', require: false
end

group :production do
  # errors+logging
  gem 'rollbar'
end

# administration
gem 'administrate'

# api
gem 'active_model_serializers'
gem 'api-pagination'
gem 'jbuilder'

# authentication
gem 'authie'
gem 'omniauth'
gem 'omniauth-oauth2'
gem 'omniauth-twitch'
gem 'patreon', '< 0.3.0'

# authorization
gem 'cancancan'
gem 'doorkeeper'

# db
gem 'activerecord-import'
gem 'arel'
gem 'aws-sdk-rails'
gem 'aws-sdk-s3'
gem 'fakes3'
gem 'pg'
gem 'pg_search'

# errors+logging
gem 'newrelic_rpm'

# external communication
gem 'httparty'
gem 'rest-client'

# heroku
gem 'platform-api'

# javascript
gem 'coffee-rails'

# models
gem 'has_secure_token'
gem 'nilify_blanks'

# parsing
gem 'descriptive_statistics'
gem 'moving_average'
gem 'nokogiri'

# server/environment
gem 'puma'
gem 'rails', '~> 5'

# speediness
gem 'dalli'
gem 'turbolinks', github: 'rails/turbolinks'

# views
gem 'bootstrap'
gem 'bootstrap4-kaminari-views'
gem 'bootswatch'
gem 'flat-ui-rails'
gem 'font-awesome-sass', '~> 5.0.9'
gem 'gon'
gem 'htmlentities'
gem 'kaminari'
gem 'purecss-rails', github: 'glacials/purecss-rails'
gem 'sass-rails'
gem 'slim'
gem 'uglifier'
gem 'webpacker'

# workers/jobs
gem 'delayed_job_active_record'
gem 'foreman'
