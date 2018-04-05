if SplitsIO::Application.config.read_only
  module ActiveRecord::Base
    def readonly?
      true
    end
  end
end
