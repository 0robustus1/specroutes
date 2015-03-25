module Specroutes::Routing
  module Interface
    class ResourcePart
      attr_accessor :path

      def initialize(path)
        self.path = path
      end

      def clean_path
        path.sub(%r{^/+}, '').sub(%r{/+$}, '')
      end
    end
  end
end
