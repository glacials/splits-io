class RemovePermagold < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :permagold
  end
end
