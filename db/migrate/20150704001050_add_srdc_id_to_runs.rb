class AddSrdcIdToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :srdc_id, :string
  end
end
