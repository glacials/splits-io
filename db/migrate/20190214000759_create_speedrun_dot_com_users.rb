class CreateSpeedrunDotComUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :speedrun_dot_com_users, id: :uuid do |t|
      t.belongs_to :user, foreign_key: true, null: false, index: {unique: true}

      t.string :srdc_id, null: false, index: {unique: true}
      t.string :name,    null: false
      t.string :url,     null: false
      t.string :api_key, null: false, index: {unique: true}

      t.timestamps
    end
  end
end
