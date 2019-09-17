class RunValidator < ActiveModel::Validator
  def validate(record)
    validate_default_timing(record)
  end

  private

  def validate_default_timing(record)
    return if %w[real game].include?(record.default_timing)
    record.errors[:base] << 'Default timing must be either "real" or "game".'
  end
end
