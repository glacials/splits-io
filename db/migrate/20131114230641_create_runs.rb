class CreateRuns < ActiveRecord::Migration
  def change
    create_table :runs do |t|
      t.references :user, index: true
      t.string :file
      t.string :type

      t.timestamps
    end
  end
end
