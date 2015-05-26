class RenamePositionToOrder < ActiveRecord::Migration
  def change
    rename_column :segments, :position, :order
  end
end
