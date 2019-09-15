class MigrateRunVideoUrlsToVideos < ActiveRecord::Migration[6.0]
  def up
    # video_url is included in ignored_columns in Run, so we can't use standard ActiveRecord stuff to create Videos
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
    Video.find_each do |video|
      video.run.update(video_url: video.url)
    end
  end
end
