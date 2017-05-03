class AddSrdcIdToRuns < ActiveRecord::Migration[4.2]
  def change
    add_column :runs, :srdc_id, :string
  end
end
