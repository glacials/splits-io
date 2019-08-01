class RaceValidator < ActiveModel::Validator
  def validate(record)
    game_from_category(record)
    validate_game(record)
    validate_category(record)
  end

  private

  def game_from_category(record)
    return unless record.game_id.nil? && record.category_id.present?
    return unless Category.find_by(id: record.category_id)

    record.game_id = record.category.game_id
  end

  def validate_game(record)
    return if record.game_id.nil?
    return if Game.find_by(id: record.game_id)

    record.errors[:base] << "Game with id '#{record.game_id}' does not exist"
  end

  def validate_category(record)
    return if record.category_id.nil?
    return if record.game_id.present? && Game.find(record.game_id).categories.find_by(id: record.category_id)

    record.errors[:base] << "Category with id '#{record.category_id}' inside game with id '#{record.game_id}' does not exist"
  end
end
