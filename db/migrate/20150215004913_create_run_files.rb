class CreateRunFiles < ActiveRecord::Migration
  def change
    create_table :run_files do |t|
      t.string :digest
      t.text :file
    end
    add_index :run_files, :digest
  end
end
