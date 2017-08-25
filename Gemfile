source 'https://rubygems.org'
ruby '2.3.4'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

group :test, :development do
  gem 'pry-rails'
end

group :test do
  # tests
  gem 'factory_girl_rails', require: false
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

  # pretty things
  gem 'rails-erd', require: false
  gem 'rubocop', require: false

  # tests
  gem 'guard', require: false
  gem 'guard-rspec', require: false
end

group :production do
  # errors+logging
  gem 'rails_stdout_logging'
  gem 'rollbar'

  # heroku
  gem 'rails_12factor'
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
gem 'patreon'

# authorization
gem 'cancancan'
gem 'doorkeeper'

# db
gem 'activerecord-import'
gem 'arel'
gem 'aws-sdk-rails'
gem 'fakes3'
gem 'pg'

# errors+logging
gem 'newrelic_rpm'

# external communication
gem 'httparty'
gem 'rest-client'

# heroku
gem 'platform-api'

# javascript
gem 'bower-rails'
gem 'clipboard-rails'
gem 'coffee-rails'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'js_cookie_rails'
gem 'numeraljs-rails'
gem 'spinjs-rails'
gem 'tipsy-rails'
gem 'underscore-rails'
gem 'momentjs-rails'
gem 'd3-rails', '~> 3.5.17'
gem 'c3-rails'

# models
gem 'has_secure_token'
gem 'nilify_blanks'

# parsing
gem 'babel_bridge'
gem 'chronic_duration', github: 'glacials/chronic_duration', branch: 'pad_to_option'
gem 'descriptive_statistics'
gem 'moving_average'
gem 'nokogiri'
gem 'ptools'
gem 'versionomy'
gem 'xml-simple'

# server/environment
gem 'figaro'
gem 'rails', '~> 5'
gem 'thin'
gem 'unicorn'

# speediness
gem 'dalli'
gem 'jquery-turbolinks'
gem 'turbolinks', github: 'rails/turbolinks'

# views
gem 'bootstrap-kaminari-views'
gem 'bootstrap-sass'
gem 'bootswatch-rails'
gem 'flat-ui-rails'
gem 'gon'
gem 'htmlentities'
gem 'kaminari'
gem 'purecss-rails', github: 'glacials/purecss-rails'
gem 'sass-rails'
gem 'slim'
gem 'uglifier'

# workers/jobs
gem 'delayed_job_active_record'
gem 'foreman'
