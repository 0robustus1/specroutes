module Specroutes::Routing
  module Interface
    class RouteSpecification
      attr_accessor :path, :options, :method, :to

      def initialize(method, args)
        self.method = method
        self.options = args.extract_options!
        if args.any?
          self.path = args.first
        else
          self.path, self.to = options.find { |k, _v| k.is_a?(String) }
        end
      end

      def register(specification)
        specification.register(self)
      end

      def match_options
        if to
          [options.merge(via: method).merge(path => to)]
        else
          [path, options.merge(via: method)]
        end
      end

      def identifier
        path
      end

      def define_constraints
        raise NotImplementedError, 'method define_constraints is not implemented, yet'
      end
    end
  end
end
