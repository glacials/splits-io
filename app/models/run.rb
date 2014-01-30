class Run < ActiveRecord::Base
  belongs_to :user
  after_destroy :delete_source_file

  def delete_source_file
    File.delete('private/runs/' + nick)
  end
end
