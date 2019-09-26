class RemoveVideoUrlFromRuns < ActiveRecord::Migration[6.0]
  def change
    safety_assured { remove_column :runs, :video_url, :string }
  end
end
