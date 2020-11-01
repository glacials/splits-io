source 'https://rubygems.org'
ruby '2.7.1' # also update docker-compose.yml & docker-compose-production.yml

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

group :test, :development do
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-rails', '~> 4.0.0'
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
  gem 'rubocop-rails', require: false

  # profiling
  gem 'derailed_benchmarks'

  # views
  gem 'rails_real_favicon'

  gem 'listen'
end

group :production do
  # errors+logging
  gem 'rollbar'

  # null db for asset precompile in docker
  gem 'activerecord-nulldb-adapter'
end

# administration
gem 'administrate'
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
gem 'bcrypt'
gem 'omniauth'
gem 'omniauth-oauth2'
gem 'omniauth-google-oauth2'
gem 'omniauth-twitch', github: 'WebTheoryLLC/omniauth-twitch'
gem 'patreon', '< 0.3.0'

# authorization
gem 'cancancan'
gem 'doorkeeper'

# db
gem "active_median"
gem "active_record_union"
gem "activerecord-import"
gem "aws-sdk-rails"
gem "aws-sdk-s3"
gem "friendly_uuid"
gem "order_as_specified"
gem "pg"
gem "pg_search"
gem "strong_migrations"

# errors+logging
gem 'newrelic_rpm'
gem 'skylight', '~> 4.0.0'

# external communication
gem 'httparty'
gem 'rest-client'
gem 'stripe-rails'

# parsing
gem 'descriptive_statistics', require: 'descriptive_statistics/safe'
gem 'moving_average'

# profiling
gem 'memory_profiler'
gem 'rack-mini-profiler'

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
gem 'image_processing'
gem 'kaminari'
gem 'purecss-rails', github: 'glacials/purecss-rails'
gem 'sassc-rails'
gem 'slim'
gem 'webpacker', '>= 4.0.x'

# workers/jobs
gem 'daemons'
gem 'delayed_job_active_record'
gem 'redis'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
