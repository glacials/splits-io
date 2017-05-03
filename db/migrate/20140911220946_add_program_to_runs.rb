class AddProgramToRuns < ActiveRecord::Migration[4.2]
  def change
    add_column :runs, :program, :string
  end
end
