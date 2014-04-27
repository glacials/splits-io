class MoveRunFilesToDatabase < ActiveRecord::Migration
  def up
    Run.all.each do |run|
      if File.exist?(Rails.root.join('private', 'runs', run.nick))
        run.file = File.read(Rails.root.join('private', 'runs', run.nick))
        run.save
      end
    end
  end
  def down
    Run.all.each do |run|
      if run.file.present?
        File.open(Rails.root.join('private', 'runs', run.nick), 'wb') do |file|
          file.write run.file
          run.file = nil
          run.save
        end
      end
    end
  end
end
