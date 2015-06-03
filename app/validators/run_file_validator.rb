Dir['./lib/parsers/*'].each { |file| require file }

class RunFileValidator < ActiveModel::Validator
  def validate(run_file)
    validate_file_format(run_file)
  end

  private

  def validate_file_format(run_file)
    RunFile.programs.any? do |program|
      begin
        program.read!(run_file)
      rescue
        next
      end
    end || run_file.errors[:file] << "Couldn't parse that file."
  end
end
