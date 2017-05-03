class AddVideoUrlToRuns < ActiveRecord::Migration[4.2]
  def change
    add_column :runs, :video_url, :string
  end
end
