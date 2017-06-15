class RunFile < ApplicationRecord
  def self.random
    RunFile.offset(rand(RunFile.count)).first
  end

  private

  def self.for_text(file_text)
    digest = Digest::SHA256.hexdigest(file_text)
    where(digest: digest).first_or_create(file: file_text)
  end

  def self.is_llanfair?(file_text)
    file_text[8..29] == "org.fenix.llanfair.Run"
  end
end
