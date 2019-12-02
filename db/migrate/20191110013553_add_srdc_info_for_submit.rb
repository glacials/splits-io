class AddSrdcInfoForSubmit < ActiveRecord::Migration[6.0]
  def change
    add_column :runs, :uses_emulator, :boolean, default: false

    add_column :speedrun_dot_com_games, :video_required, :boolean
    add_column :speedrun_dot_com_games, :accetps_realtime, :boolean
    add_column :speedrun_dot_com_games, :accepts_gametime, :boolean
    add_column :speedrun_dot_com_games, :emulators_allowed, :boolean

    reversible do |dir|
      dir.down do
        SpeedrunDotComGame.where('created_at > ?', Time.new(2019, 12, 1)).destroy_all
      end
    end

    create_table :speedrun_dot_com_game_variables, id: :uuid do |t|
      t.string :srdc_id
      t.string :type, null: false
      t.string :name, null: false
      t.belongs_to :speedrun_dot_com_game, null: false, index: {name: 'index_srdc_game_variables_on_srdc_game_id'}
      t.belongs_to :speedrun_dot_com_category, index: {name: 'index_srdc_game_variables_on_srdc_category_id'}
      t.boolean :mandatory
      t.boolean :obsoletes
      t.boolean :user_defined
      t.index [:srdc_id, :type], unique: true
      t.timestamps
    end

    create_table :speedrun_dot_com_game_variable_values, id: :uuid do |t|
      t.belongs_to :speedrun_dot_com_game_variables, null: false, index: {name: 'index_srdc_game_variable_values_on_srdc_game_variables_id'}
      t.string :srdc_id, null: false
      t.string :label, null: false
      t.string :rules
      t.boolean :miscellaneous
      t.timestamps
    end

    create_table :speedrun_dot_com_run_variables, id: :uuid do |t|
      t.belongs_to :speedrun_dot_com_game_variable_value, index: {name: 'index_srdc_run_variables_on_srdc_game_variable_value_id'}
      t.belongs_to :run
      t.timestamps
    end
  end
end
