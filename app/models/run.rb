class Run < ActiveRecord::Base
  belongs_to :user
  before_create :generate_nick
  before_destroy :delete_source_file

  @@parsers = [WsplitParser, TimesplittrackerParser, SplitterzParser, LivesplitParser]
  @parse_cache = nil

  def generate_nick
    loop do
      self.nick = SecureRandom.urlsafe_base64(3)
      return if Run.find_by(nick: self.nick).nil?
    end
  end

  def delete_source_file
    File.delete('private/runs/' + self.nick)
  end

  def name
    self.parse.name
  end

  def splits
    self.parse.splits
  end

  def time
    self.parse.time
  end

  def offset
    self.parse.offset
  end

  def attempts
    self.parse.attempts
  end

  def game
    self.parse.game
  end

  def parse
    if @parse_cache
      return @parse_cache
    end

    splits = File.read(Rails.root.join('private', 'runs', self.nick))

    begin
      @@parsers.each do |p|
        result = p.new.parse(splits) and return result
      end
    rescue ArgumentError # comes from non UTF-8 files
      return nil
    end

    return nil
  end

end
