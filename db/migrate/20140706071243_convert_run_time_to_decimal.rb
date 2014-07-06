class ConvertRunTimeToDecimal < ActiveRecord::Migration
  def change
    remove_column :runs, :time
    add_column :runs, :time, :decimal
  end
end
