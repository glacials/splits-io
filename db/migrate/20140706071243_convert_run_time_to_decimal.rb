class ConvertRunTimeToDecimal < ActiveRecord::Migration[4.2]
  def change
    remove_column :runs, :time
    add_column :runs, :time, :decimal
  end
end
