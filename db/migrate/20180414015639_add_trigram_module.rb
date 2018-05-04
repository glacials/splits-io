class AddTrigramModule < ActiveRecord::Migration[5.1]
  def up
    execute 'CREATE EXTENSION pg_trgm;'
  end

  def down
    execute 'DROP EXTENSION pg_trgm;'
  end
end
