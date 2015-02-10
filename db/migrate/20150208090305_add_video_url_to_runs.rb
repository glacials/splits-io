class AddVideoUrlToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :video_url, :string
  end
end
