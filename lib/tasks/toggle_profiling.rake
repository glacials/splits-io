require 'fileutils'

FILE = 'tmp/profiling-dev.txt'.freeze

desc 'Toggle local production mode for profiling'
task :toggle_profiling do
  if File.exist?(FILE)
    File.delete(FILE)
  else
    FileUtils.touch(FILE)
  end
end
