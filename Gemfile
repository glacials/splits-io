source 'https://rubygems.org'
ruby '2.2.4'

group :test do
  # tests
  gem 'factory_girl_rails', require: false
  gem 'rspec-rails', require: false
  gem 'simplecov', require: false
end

group :development, :hot do
  # errors+logging
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
  # errors+logging
  gem 'rails_stdout_logging'
  gem 'rollbar'

  # heroku
  gem 'rails_12factor'
end

# api
gem 'active_model_serializers', github: 'rails-api/active_model_serializers'
gem 'api-pagination'
gem 'jbuilder'

# authentication
gem 'authie', github: 'glacials/authie'
gem 'omniauth'
gem 'omniauth-twitch'

# db
gem 'arel', github: 'rails/arel'
gem 'pg'

# errors+logging
# gem 'newrelic_rpm', github: 'newrelic/rpm' # no rails 5 support yet

# external communication
gem 'httparty'
gem 'rest-client'

# heroku
gem 'platform-api'

# javascript
gem 'coffee-rails'
gem 'jquery-rails'
gem 'jquery-cookie-rails'
gem 'numeraljs-rails'
gem 'spinjs-rails'
gem 'tipsy-rails'
gem 'underscore-rails'

# models/db
gem 'has_secure_token'
gem 'nilify_blanks'

# parsing
gem 'babel_bridge'
gem 'chronic_duration', github: 'glacials/chronic_duration', branch: 'pad_to_option'
gem 'moving_average'
gem 'ptools'
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
