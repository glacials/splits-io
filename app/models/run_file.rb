class RunFile < ApplicationRecord
  def self.for_file(file)
    if file.respond_to?(:read)
      file_text = file.read
      RunFile.is_llanfair?(file_text) ? RunFile.for_binary(file_text) : RunFile.for_text(file_text)
    end
  end

  def self.for_convert(file)
    if file.respond_to?(:read)
      file_text = file.read
      if RunFile.is_llanfair?(file_text)
        run_file = RunFile.new(file: RunFile.unpack_binary(file_text))
      else
        run_file = RunFile.new(file: file_text)
      end
    end
  end

  def self.random
    RunFile.offset(rand(RunFile.count)).first
  end

  private

  def self.for_text(file_text)
    digest = Digest::SHA256.hexdigest(file_text)
    where(digest: digest).first_or_create(file: file_text)
  end

  def self.for_binary(file_text)
    digest = Digest::SHA256.hexdigest(file_text)
    where(digest: digest).first_or_create(file: RunFile.unpack_binary(file_text))
  end

  def self.is_llanfair?(file_text)
    file_text[8..29] == "org.fenix.llanfair.Run"
  end

  def self.unpack_binary(file_text)
    file_text.unpack("C*")
  end

  def self.pack_binary(character_array)
    character_array[1..-1].split(", ").map(&:to_i).pack("C*")
  end
end
