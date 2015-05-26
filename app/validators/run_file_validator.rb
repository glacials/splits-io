Dir['./lib/parsers/*'].each { |file| require file }

class RunFileValidator < ActiveModel::Validator
  def validate(run_file)
    validate_file_format(run_file)
  end

  private

  def validate_file_format(run_file)
    RunFile.programs.any? do |program|
      program.read!(run_file)
    end || run_file.errors[:base] << "Couldn't parse that file."
  end
end
