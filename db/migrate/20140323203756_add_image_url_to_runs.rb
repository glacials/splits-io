class AddImageUrlToRuns < ActiveRecord::Migration[4.2]
  def change
    add_column :runs, :image_url, :string
  end
end
