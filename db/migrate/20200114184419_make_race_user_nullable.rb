class MakeRaceUserNullable < ActiveRecord::Migration[6.0]
  def change
    change_column_null :races, :user_id, true
    change_column_null :chat_messages, :user_id, true
  end
end
