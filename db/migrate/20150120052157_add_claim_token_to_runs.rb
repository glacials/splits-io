class AddClaimTokenToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :claim_token, :string
  end
end
