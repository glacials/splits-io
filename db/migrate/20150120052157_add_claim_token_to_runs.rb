class AddClaimTokenToRuns < ActiveRecord::Migration[4.2]
  def change
    add_column :runs, :claim_token, :string
  end
end
