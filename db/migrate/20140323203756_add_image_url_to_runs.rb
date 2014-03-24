class AddImageUrlToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :image_url, :string
  end
end
