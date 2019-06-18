class AddRunToEntrants < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    add_reference :entrants, :run, index: false, null: true
    add_foreign_key :entrants, :runs, algorithm: :concurrently
  end
end
