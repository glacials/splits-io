class AddRacingForeignKeysAndIndexes < ActiveRecord::Migration[6.0]
  def change
    safety_assured do
      add_foreign_key :races, :games
      add_foreign_key :entries, :races
      add_foreign_key :chat_messages, :races

      add_index :entries, :race_id
      add_index :chat_messages, :race_id
    end
  end
end
