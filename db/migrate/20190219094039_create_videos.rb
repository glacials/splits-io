class CreateVideos < ActiveRecord::Migration[5.2]
  def up
    create_table :videos, id: :uuid do |t|
      t.string :url, null: false
      t.references :videoable, polymorphic: true, index: true
      t.timestamps
    end

    Run.where.not(video_url: nil).each do |r|
      Video.create!(videoable: r, url: r.video_url)
    end

    safety_assured { remove_column :runs, :video_url }
  end

  def down
    add_column :runs, :video_url, :string

    Video.find_each do |v|
      v.videoable.update(video_url: v.url)
    end

    drop_table :videos
  end
end
