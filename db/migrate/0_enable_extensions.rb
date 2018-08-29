class EnableExtensions < ActiveRecord::Migration[5.0]
  def change
    enable_extension 'uuid-ossp'
    enable_extension 'pgcrypto'
  end
end
