source 'https://rubygems.org'
ruby '2.1.5'

group :test, :development do
  # tests
  gem 'factory_girl_rails'
  gem 'rspec-rails'
end

group :development, :hot do
  # debugging
  gem 'byebug'
  gem 'pry-rails'
  gem 'web-console'

  # general ease of development
  gem 'guard'
  gem 'guard-rails'
  gem 'guard-rspec'

  # pretty things
  gem 'awesome_print'
  gem 'rubocop', require: false
end

group :production do
  gem 'rollbar'
end

# api
gem 'active_model_serializers'
gem 'api-pagination'
gem 'jbuilder'

# authentication
gem 'devise'

# caching
gem 'dalli'

# db
gem 'pg'

# external communication
gem 'httparty'

# heroku
gem 'platform-api'
gem 'rails_12factor'

# logging
gem 'newrelic_rpm'
gem 'rails_stdout_logging'

# models/db
gem 'has_secure_token'
gem 'nilify_blanks'
gem 'squeel'

# parsing
gem 'babel_bridge'
gem 'chronic_duration', git: 'https://github.com/glacials/chronic_duration', branch: 'pad_to_option'
gem 'moving_average'
gem 'versionomy'
gem 'xml-simple'

# server/environment
gem 'figaro'
gem 'rails'
gem 'thin'
gem 'unicorn'

# views
gem 'bootstrap-sass'
gem 'flat-ui-rails'
gem 'gon'
gem 'haml-rails'
gem 'htmlentities'
gem 'jquery-rails'
gem 'purecss-rails'
gem 'sass-rails'
gem 'slim'
gem 'spinjs-rails'
gem 'tipsy-rails'
gem 'uglifier'
gem 'will_paginate'

# workers/jobs
gem 'delayed_job_active_record'
gem 'foreman'
gem 'workless'
