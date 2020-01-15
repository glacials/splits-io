class AddFkAndIndexToSrdcGameVariables < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    safety_assured {
      add_reference :speedrun_dot_com_game_variables,
                    :speedrun_dot_com_game_variable_values,
                    type: :uuid,
                    index: {
                      name: 'index_srdc_game_variables_on_srdc_game_variable_values_id',
                      algorithm: :concurrently
                    }
    }
  end
end
