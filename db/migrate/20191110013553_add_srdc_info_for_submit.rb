class AddSrdcInfoForSubmit < ActiveRecord::Migration[6.0]
  def change
    add_column :runs, :uses_emulator, :boolean, default: false

    add_column :speedrun_dot_com_games, :video_required, :boolean
    add_column :speedrun_dot_com_games, :accepts_realtime, :boolean
    add_column :speedrun_dot_com_games, :accepts_gametime, :boolean
    add_column :speedrun_dot_com_games, :emulators_allowed, :boolean

    create_table :speedrun_dot_com_game_variables, id: :uuid do |t|
      t.string :srdc_id, unique: true
      t.string :name, null: false
      t.belongs_to :speedrun_dot_com_game, type: :uuid, null: false, index: {name: 'index_srdc_game_variables_on_srdc_game_id'}, foreign_key: true
      t.belongs_to :speedrun_dot_com_category, type: :uuid, index: {name: 'index_srdc_game_variables_on_srdc_category_id'}, foreign_key: true
      t.boolean :mandatory
      t.boolean :obsoletes
      t.boolean :user_defined
      t.string :game_scope, null: false
      t.timestamps
    end

    create_table :speedrun_dot_com_game_variable_values, id: :uuid do |t|
      t.belongs_to :speedrun_dot_com_game_variable, type: :uuid, null: false, index: {name: 'index_srdc_game_variable_values_on_srdc_game_variables_id'}, foreign_key: true
      t.string :srdc_id, null: false
      t.string :label, null: false
      t.string :rules
      t.boolean :miscellaneous
      t.timestamps
    end

    create_table :speedrun_dot_com_run_variables, id: :uuid do |t|
      t.belongs_to :speedrun_dot_com_game_variable_value, type: :uuid, index: {name: 'index_srdc_run_variables_on_srdc_game_variable_value_id'}, foreign_key: true
      t.belongs_to :run, foreign_key: true
      t.timestamps
    end

    create_table :speedrun_dot_com_regions, id: :uuid do |t|
      t.string :srdc_id, null: false, unique: true
      t.string :name,    null: false, unique: true
    end

    create_table :speedrun_dot_com_platforms, id: :uuid do |t|
      t.string :srdc_id, null: false, unique: true
      t.string :name,    null: false, unique: true
    end

    add_reference :runs, :speedrun_dot_com_platform, type: :uuid, foreign_key: true, index: false
    add_reference :runs, :speedrun_dot_com_region,   type: :uuid, foreign_key: true, index: false

    create_table :speedrun_dot_com_game_platforms, id: :uuid do |t|
      t.belongs_to :speedrun_dot_com_game, type: :uuid, foreign_key: true, index: {name: 'index_srdc_game_platforms_on_srdc_games_id'}
      t.belongs_to :speedrun_dot_com_platform, type: :uuid, foreign_key: true, index: {name: 'index_srdc_game_platforms_on_srdc_platforms_id'}
    end

    create_table :speedrun_dot_com_game_regions, id: :uuid do |t|
      t.belongs_to :speedrun_dot_com_game, type: :uuid, foreign_key: true, index: {name: 'index_srdc_game_regions_on_srdc_games_id'}
      t.belongs_to :speedrun_dot_com_region, type: :uuid, foreign_key: true, index: {name: 'index_srdc_game_regions_on_srdc_regions_id'}
    end
  end
end
