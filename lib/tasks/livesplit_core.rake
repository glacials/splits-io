require 'open-uri'
require 'rubygems/package'
require 'zlib'
require 'httparty'

LIVESPLIT_CORE_URL = "https://api.github.com/repos/LiveSplit/livesplit-core/releases/latest"
PARSER_FOLDER = "#{Rake.application.original_dir}/lib/parser"
DEST_FOLDER = "#{Rake.application.original_dir}/lib/parser/livesplit-core"
CURRENT_LSC_VERSION = open("#{PARSER_FOLDER}/livesplit_core_version", "r") {|f| f.read }
LIVESPLIT_CORE_TARGET = "livesplit-core-%s-x86_64-unknown-linux-gnu.tar.gz"

desc 'Download and update livesplit-core'
task :update_lsc do
  latest_release = HTTParty.get(LIVESPLIT_CORE_URL)

  if latest_release['tag_name'] == CURRENT_LSC_VERSION
    puts 'livesplit-core is already up to date!'
    next
  end

  download_url = nil
  latest_release['assets'].each do |asset|
    next unless asset['name'] == LIVESPLIT_CORE_TARGET % [latest_release['tag_name']]
    download_url = asset['browser_download_url']
    break
  end
  if download_url.nil?
    puts 'No livesplit-core version suitable!'
    next
  end
  io = StringIO.new(HTTParty.get(download_url))
  z = Zlib::GzipReader.new(io)
  io = StringIO.new(z.read)
  z.close

  Gem::Package::TarReader.new io do |tar|
    tar.each do |tarfile|
      dest_file = File.join(DEST_FOLDER, tarfile.full_name)

      if tarfile.directory?
        mkdir_p dest_file
      else
        file = File.dirname(dest_file)
        File.open(dest_file, "wb") do |f|
          f.print tarfile.read
        end
      end
    end
  end

  mv("#{DEST_FOLDER}/liblivesplit_core.so", "#{PARSER_FOLDER}/liblivesplit_core.so")
  mv("#{DEST_FOLDER}/bindings/LiveSplitCore.rb", "#{PARSER_FOLDER}/LiveSplitCore.rb")
  rm_rf DEST_FOLDER
  open("#{PARSER_FOLDER}/livesplit_core_version", "w") {|f| f.write(latest_release['tag_name']) }
end
