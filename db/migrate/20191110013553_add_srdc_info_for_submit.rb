class AddSrdcInfoForSubmit < ActiveRecord::Migration[6.0]
  def change
    change_table :speedrun_dot_com_games do |t|
      t.boolean :video_required
      t.boolean :accetps_realtime
      t.boolean :accepts_gametime
      t.boolean :emulators_allowed
    end

    reversible do |dir|
      dir.down do
        SpeedrunDotComGame.where('created_at > ?', Time.new(2019, 11, 11)).destroy_all
      end
    end

    create_table :speedrun_dot_com_game_variables, id: :uuid do |t|
      t.string :srdc_id, null: false
      t.string :type, null: false
      t.string :name, null: false
      t.belongs_to :speedrun_dot_com_game, null: false
      t.belongs_to :speedrun_dot_com_category
      t.boolean :mandatory
      t.boolean :obsoletes
      t.boolean :user_defined
      t.references :default_value, index: true, foreign_key: {to_table: :speedrun_dot_com_game_variable_values}
      t.index[:srdc_id, :type], unique: true
      t.timestamps
    end

    create_table :speedrun_dot_com_game_variable_values, id: :uuid do |t|
      t.belongs_to :speedrun_dot_com_game_variables, null: false
      t.string :srdc_id, null: false
      t.string :label, null: false
      t.string :rules
      t.boolean :miscellaneous
      t.timestamps
    end

    create_table :speedrun_dot_com_run_variables, id: :uuid do |t|
      t.belongs_to :speedrun_dot_com_game_variable_value
      t.belongs_to :run
      t.timestamps
    end
  end
end
