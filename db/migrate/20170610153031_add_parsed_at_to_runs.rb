class AddParsedAtToRuns < ActiveRecord::Migration[5.0]
  def change
    add_column :runs, :parsed_at, 'timestamp without time zone'
  end
end
