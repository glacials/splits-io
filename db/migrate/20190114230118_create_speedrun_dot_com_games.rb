class CreateSpeedrunDotComGames < ActiveRecord::Migration[5.2]
  def change
    create_table :speedrun_dot_com_games, id: :uuid do |t|
      t.belongs_to :game, foreign_key: true
      t.string :srdc_id,        null: false
      t.string :name,           null: false
      t.string :shortname,      null: true, index: true
      t.string :url,            null: false
      t.string :favicon_url,    null: true
      t.string :cover_url,      null: true
      t.string :default_timing, null: false
      t.boolean :show_ms,       null: false

      t.timestamps
    end
  end
end
