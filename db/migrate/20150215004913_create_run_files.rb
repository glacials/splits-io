class CreateRunFiles < ActiveRecord::Migration[4.2]
  def change
    create_table :run_files do |t|
      t.string :digest
      t.text :file
    end
    add_index :run_files, :digest
  end
end
