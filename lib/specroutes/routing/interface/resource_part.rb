module Specroutes::Routing
  module Interface
    class ResourcePart
      attr_accessor :path

      def initialize(path)
        self.path = path
      end
    end
  end
end
