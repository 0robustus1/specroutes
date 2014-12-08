module Specroutes::Routing
  module Interface
    class RouteSpecification
      attr_accessor :rails_path, :options, :method, :to
      attr_accessor :query_params

      def initialize(method, args)
        self.method = method
        self.options = args.extract_options!
        if args.any?
          self.rails_path = args.first
        else
          self.rails_path, self.to = options.find { |k, _v| k.is_a?(String) }
        end
        split_rails_path!
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

      def path
        rails_path.gsub(/:([^\/]+)/, '{\1}')
      end

      def identifier
        rails_path
      end

      def define_constraints
        raise NotImplementedError, 'method define_constraints is not implemented, yet'
      end

      private
      def split_rails_path!
        self.rails_path, query_params = rails_path.split('?')
        self.query_params = query_params.to_s.split(/;&/)
      end
    end
  end
end
