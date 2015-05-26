class TransferSegmentsToRunFiles < ActiveRecord::Migration
  def change
    remove_column :segments, :run_id
    add_reference :segments, :run_file, index: true
  end
end
