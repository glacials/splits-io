source 'https://rubygems.org'
ruby '2.2.2'

group :development, :test do
  # tests
  gem 'factory_girl_rails'
  #gem 'rspec-rails' # removed until updated for rails 5
  gem 'simplecov', require: false
end

group :development, :hot do
  # error pages
  gem 'better_errors'
  gem 'binding_of_caller'

  # debugging
  gem 'meta_request'
  gem 'pry-rails'

  # pretty things
  gem 'awesome_print'
  gem 'rails-erd', require: false
  gem 'rubocop', require: false

  # tests
  gem 'guard'
  gem 'guard-rspec'
end

group :production do
  gem 'rollbar'
end

# api
gem 'active_model_serializers'
gem 'api-pagination'
gem 'jbuilder'

# authentication
gem 'authie'
gem 'omniauth'
gem 'omniauth-twitch'

# db
gem 'arel', github: 'rails/arel'
gem 'pg'

# external communication
gem 'httparty'
gem 'rest-client'

# heroku
gem 'platform-api'
gem 'rails_12factor'

# javascript
gem 'coffee-rails'
gem 'jquery-rails'
gem 'numeraljs-rails'
gem 'spinjs-rails'
gem 'tipsy-rails'
gem 'underscore-rails'

# logging
# gem 'newrelic_rpm', github: 'newrelic/rpm' # no rails 5 support yet
gem 'rails_stdout_logging'

# models/db
gem 'has_secure_token'
gem 'nilify_blanks'

# parsing
gem 'babel_bridge'
gem 'chronic_duration', github: 'glacials/chronic_duration', branch: 'pad_to_option'
gem 'moving_average'
gem 'versionomy'
gem 'xml-simple'

# server/environment
gem 'figaro'
gem 'rails', github: 'rails/rails'
gem 'thin'
gem 'unicorn'

# speediness
gem 'dalli'
gem 'jquery-turbolinks'
gem 'turbolinks', github: 'rails/turbolinks'

# views
gem 'bootstrap-sass'
gem 'flat-ui-rails'
gem 'gon'
gem 'haml-rails'
gem 'htmlentities'
gem 'purecss-rails'
gem 'sass-rails'
gem 'slim'
gem 'uglifier'
gem 'will_paginate'

# workers/jobs
gem 'delayed_job_active_record'
gem 'foreman'
gem 'workless'
