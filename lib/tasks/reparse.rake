desc 'Reparse all runs and update their corresponding database information to match.'
task reparse: [:environment] do
  Run.all.each do |run|
    if run.parse.present?
      game = Game.find_by(name: run.parsed.game) || Game.create(name: run.parsed.game)
      run.category = Category.find_by(game: game, name: run.parsed.category) || game.categories.new(game: game, name: run.parsed.category)
      run.save
    end
  end
end
