FactoryGirl.define do
  factory :run do
    run_file RunFile.for_file(File.open("#{Rails.root}/spec/factories/run_files/livesplit_1"))
  end
end
