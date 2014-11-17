module Specroutes::Routing
  module Interface
    class RouteSpecification
      attr_accessor :path, :options

      def initialize(path, options)
        self.path = path
        self.options = options
      end

      def register(specification)
        specification.register(self)
      end

      def define_constraints
        raise NotImplementedError, 'method define_constraints is not implemented, yet'
      end
    end
  end
end
