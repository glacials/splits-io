source 'https://rubygems.org'
ruby '2.6.0'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

group :test, :development do
  gem 'pry-rails'
  gem 'rspec-rails', '~> 4.0.0.beta2'
end

group :test do
  # tests
  gem 'factory_bot_rails', require: false
  gem 'json-schema'
  gem 'json-schema-rspec'
  gem 'rails-controller-testing'
  gem 'simplecov', require: false
end

group :development, :hot do
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

  gem 'listen'
end

group :production do
  # errors+logging
  gem 'rollbar'
end

# administration
gem 'administrate', github: 'thoughtbot/administrate'
gem 'chartkick'
gem 'groupdate'

# api
gem 'api-pagination'
gem 'blueprinter'
gem 'jbuilder'
gem 'oj'
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
gem 'aws-sdk-rails'
gem 'aws-sdk-s3'
gem 'order_as_specified'
gem 'pg'
gem 'pg_search'
gem 'strong_migrations'

# errors+logging
gem 'newrelic_rpm'
gem 'skylight', '~> 4.0.0'

# external communication
gem 'httparty'
gem 'rest-client'
gem 'stripe-rails'

# models
gem 'nilify_blanks'

# parsing
gem 'descriptive_statistics', require: 'descriptive_statistics/safe'
gem 'moving_average'

# profiling
gem 'flamegraph'
gem 'memory_profiler'
gem 'rack-mini-profiler'
gem 'stackprof'

# server/environment
gem 'puma'
gem 'rails', '~> 6.0'
# see https://github.com/faye/websocket-driver-ruby/issues/58#issuecomment-394611125
gem 'websocket-driver', github: 'faye/websocket-driver-ruby', ref: 'ee39af83d03ae3059c775583e4c4b291641257b8'

# speediness
gem 'bootsnap'
gem 'dalli'

# views
gem 'bootstrap4-kaminari-views'
gem 'font-awesome-sass', '~> 5.9'
gem 'gon'
gem 'kaminari'
gem 'purecss-rails', github: 'glacials/purecss-rails'
gem 'sass-rails', '~> 5.0.7'
gem 'slim'
gem 'webpacker', '>= 4.0.x'

# workers/jobs
gem 'daemons'
gem 'delayed_job_active_record', github: 'collectiveidea/delayed_job_active_record', branch: 'rails-6-compatibility'
gem 'foreman'
gem 'redis'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
