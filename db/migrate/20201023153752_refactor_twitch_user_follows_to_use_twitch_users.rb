class RefactorTwitchUserFollowsToUseTwitchUsers < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    unless ActiveRecord::Base.connection.column_exists?(:twitch_user_follows, :from_twitch_user_id)
      add_column :twitch_user_follows, :from_twitch_user_id, :uuid
      add_index :twitch_user_follows, :from_twitch_user_id, algorithm: :concurrently
    end

    unless ActiveRecord::Base.connection.column_exists?(:twitch_user_follows, :to_twitch_user_id)
      add_column :twitch_user_follows, :to_twitch_user_id, :uuid
      add_index :twitch_user_follows, :to_twitch_user_id, algorithm: :concurrently
    end

    TwitchUserFollow.where.not(from_user_id: nil, to_user_id: nil).find_each do |twitch_user_follow|
      from_twitch_user = TwitchUser.find_by(user_id: twitch_user_follow.from_user_id)
      to_twitch_user = TwitchUser.find_by(user_id: twitch_user_follow.to_user_id)
      if [from_twitch_user, to_twitch_user].any?(&:nil?)
        twitch_user_follow.destroy
        next
      end

      twitch_user_follow.update(
        from_user_id: nil,
        to_user_id: nil,
        from_twitch_user_id: from_twitch_user.id,
        to_twitch_user_id: to_twitch_user.id,
      )
    end

    # TODO: After data is shifted (above), add this line to TwitchUserFollow:
    #   self.ignored_columns = ['from_user_id', 'to_user_id']
    # Deploy that to production, then add these lines in a new migration:
    #   remove_column :twitch_user_follows, :from_user_id
    #   remove_column :twitch_user_follows, :to_user_id
    # Deploy that to production, then remove the ignored_columns line.
  end
end
