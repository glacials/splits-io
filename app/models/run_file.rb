class RunFile < ActiveRecord::Base
  has_many :runs, dependent: :restrict_with_exception, primary_key: :digest, foreign_key: :run_file_digest

  validates :digest, presence: true, uniqueness: true
  validates :file, presence: true

  def self.for_file(file)
    if file.respond_to?(:read)
      RunFile.for_text(file.read)
    end
  end

  def self.for_text(file_text)
    digest = Digest::SHA256.hexdigest(file_text)
    where(digest: digest).first_or_create(file: file_text)
  end

  def self.random
    RunFile.offset(rand(RunFile.count)).first
  end
end
