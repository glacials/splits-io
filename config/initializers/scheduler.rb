require 'rake'
require 'rufus-scheduler'

Rufus::Scheduler.singleton.every '7d' do
  rake = Rake.application
  rake.load_rakefile
  rake['srdc_sync'].invoke
end
