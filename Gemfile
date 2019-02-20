source 'https://rubygems.org'
ruby '2.6.0'

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

  # pretty things
  gem 'rails-erd', require: false
  gem 'rubocop', require: false

  # profiling
  gem 'derailed_benchmarks'

  # tests
  gem 'guard', require: false
  gem 'guard-rspec', require: false

  # views
  gem 'rails_real_favicon'
end

group :production do
  # errors+logging
  gem 'rollbar'
end

# administration
gem 'administrate'
gem 'chartkick'
gem 'groupdate'

# api
gem 'active_model_serializers'
gem 'api-pagination', '= 4.7'
gem 'jbuilder'
gem 'rack-cors', require: 'rack/cors'

# authentication
gem 'authie'
gem 'omniauth'
gem 'omniauth-oauth2'
gem 'omniauth-google-oauth2'
gem 'omniauth-twitch'
gem 'patreon', '< 0.3.0'

# authorization
gem 'cancancan'
gem 'doorkeeper'

# db
gem 'active_record_union'
gem 'activerecord-import'
gem 'arel'
gem 'aws-sdk-rails'
gem 'aws-sdk-s3'
gem 'order_as_specified'
gem 'pg'
gem 'pg_search'
gem 'strong_migrations'

# errors+logging
gem 'newrelic_rpm'
gem 'skylight'

# external communication
gem 'httparty'
gem 'rest-client'

# javascript
gem 'coffee-rails'

# models
gem 'nilify_blanks'

# parsing
gem 'descriptive_statistics'
gem 'moving_average'

# profiling
gem 'flamegraph'
gem 'memory_profiler'
gem 'rack-mini-profiler'
gem 'stackprof'

# server/environment
gem 'puma'
gem 'rails', '~> 5.2'
# see https://github.com/faye/websocket-driver-ruby/issues/58#issuecomment-394611125
gem 'websocket-driver', git: 'https://github.com/faye/websocket-driver-ruby', ref: 'ee39af83d03ae3059c775583e4c4b291641257b8'

# speediness
gem 'bootsnap'
gem 'dalli'

# views
gem 'bootstrap4-kaminari-views'
gem 'font-awesome-sass', '~> 5.1'
gem 'gon'
gem 'kaminari'
gem 'purecss-rails', github: 'glacials/purecss-rails'
gem 'sass-rails', '~> 5.0.7'
gem 'slim'
gem 'uglifier'
gem 'webpacker', '>= 4.0.x'

# workers/jobs
gem 'daemons'
gem 'delayed_job_active_record'
gem 'foreman'
gem 'redis'
