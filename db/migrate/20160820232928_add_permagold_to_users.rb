class AddPermagoldToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :permagold, :bool
  end
end
