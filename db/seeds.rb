# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# See https://github.com/rails/rails/issues/35812
ActiveJob::Base.queue_adapter = Rails.application.config.active_job.queue_adapter

Run.create(s3_filename: SecureRandom.uuid)
