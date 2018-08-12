class AddSecretGeneratedAtToApplications < ActiveRecord::Migration[5.2]
  def change
    add_column :oauth_applications, :secret_generated_at, :datetime, default: nil, null: true
    Doorkeeper::Application.update_all('secret_generated_at=created_at')
    change_column :oauth_applications, :secret_generated_at, :datetime, default: -> { 'CURRENT_TIMESTAMP' }, null: false
  end
end
