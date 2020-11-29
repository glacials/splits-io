require "rake"
require "rufus-scheduler"

# Don't run at console, during tests, or during rake tasks
return if defined?(Rails::Console) || Rails.env.test? || File.split($0).last == "rake"

CACHE_KEY = "srdc-sync-performed-recently"

Rufus::Scheduler.singleton.every "1d" do
  # Prevent multiple Rails instances from running this. Check every day if we
  # need to run, but only run once per 7 days.
  return if Rails.cache.read(CACHE_KEY)
  Rails.cache.write(CACHE_KEY, "1", expires_in: 7.days)

  rake = Rake.application
  rake.load_rakefile
  rake["srdc_sync"].invoke
end
