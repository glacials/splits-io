class MigrateRunVideoUrlsToVideos < ActiveRecord::Migration[6.0]
  # video_url is included in ignored_columns in Run, so we can't use standard ActiveRecord stuff to create Videos or rollback the migration
  def up
    sql = "INSERT INTO videos (run_id, url, created_at, updated_at)
           SELECT id, video_url, now(), now()
           FROM runs
           WHERE
             video_url IS NOT NULL
             AND video_url <> ''
          ".squish
    ActiveRecord::Base.connection.exec_insert(sql)
  end

  def down
    sql = "UPDATE runs
           SET video_url = videos.url
           FROM videos
           WHERE videos.run_id = runs.id
    ".squish
    ActiveRecord::Base.connection.exec_update(sql)
  end
end
