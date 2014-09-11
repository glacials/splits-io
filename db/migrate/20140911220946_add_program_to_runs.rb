class AddProgramToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :program, :string
  end
end
