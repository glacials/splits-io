if SplitsIO::Application.config.read_only
  module ActiveRecord
    class Base
      def readonly?
        true
      end
    end
  end
end
