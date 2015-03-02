class RunFile < ActiveRecord::Base
  has_many :runs, dependent: :restrict_with_exception, primary_key: :digest, foreign_key: :run_file_digest

  validates :digest, presence: true, uniqueness: true
  validates :file, presence: true

  def self.for_file(file)
    file_text = file.read
    digest = Digest::SHA256.hexdigest(file_text)
    where(digest: digest).first_or_create(file: file_text)
  end
end
