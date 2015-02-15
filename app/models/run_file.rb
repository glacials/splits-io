class RunFile < ActiveRecord::Base
  validates :digest, presence: true, uniqueness: true
  validates :file, presence: true

  before_validation :generate_digest

  private

  def generate_digest
    assign_attributes(digest: Digest::SHA256.hexdigest(file))
  end
end
