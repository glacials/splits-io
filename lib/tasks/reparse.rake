desc 'Reparse all runs and update their corresponding database information to match.'
task reparse: [:environment] do
  Run.all.each do |run|
    if run.parse.present?
      game = Game.find_by(name: run.parse.game) || Game.create(name: run.parse.game)
      run.category = Category.find_by(game: game, name: run.parse.category) || game.categories.new(game: game, name: run.parse.category)
      run.time = run.parse.time
      run.save
    end
  end
end
