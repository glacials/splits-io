class RaceValidator < ActiveModel::Validator
  def validate(record)
    validate_game(record)
    validate_category(record)
  end

  private

  def validate_game(record)
    return if record.game_id.nil?
    Game.find(record.game_id)
  rescue ActiveRecord::RecordNotFound
    record.errors[:base] << "Game with id #{record.game_id} does not exist"
  end

  def validate_category(record)
    return if record.category_id.nil?
    Category.find(record.category_id)
  rescue ActiveRecord::RecordNotFound
    record.errors[:base] << "Category with id #{record.category_id} does not exist"
  end
end
