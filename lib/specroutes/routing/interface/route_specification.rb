module Specroutes::Routing
  module Interface
    class RouteSpecification
      SPEC_KEYS = %w(doc docs)

      attr_accessor :rails_path, :method, :to
      attr_accessor :query_params
      attr_accessor :options, :spec_options

      def initialize(method, args)
        self.method = method
        self.options = prepare_options!(args.extract_options!)
        self.rails_path = args.first if args.any?
        split_rails_path!
      end

      def register(specification)
        specification.register(self)
      end

      def match_options
        if to
          [options.merge(via: method).merge(rails_path => to)]
        else
          [rails_path, options.merge(via: method)]
        end
      end

      def path
        rails_path.gsub(/:([^\/]+)/, '{\1}')
      end

      def identifier
        rails_path
      end

      def define_constraints
        if query_params.present?
          allowed = query_params.map { |p| p.split('=', 2).first }
          constraint_klass = Specroutes::Constraints::QueryParamConstraint
          add_to_constraints!(constraint_klass.new(allowed))
        end
      end

      def docs
        docs =
          if spec_options[:doc].is_a?(Hash)
            [spec_options[:doc]]
          else
            Array(spec_options[:doc])
          end
        docs + Array(spec_options[:docs])
      end

      private
      def add_to_constraints!(constraint)
        constraints = maybe_group(options[:constraints])
        if constraints
          constraints << constraint
        else
          constraints = constraint
        end
        options[:constraints] = constraints
      end

      def maybe_group(constraint)
        constraint && Specroutes::Constraints::GroupedConstraint.
          from(constraint)
      end

      def split_rails_path!
        self.rails_path, query_params = rails_path.split('?')
        self.query_params = query_params.to_s.split(/[;&]/)
      end

      def prepare_options!(options)
        split!(extract_mapping!(options))
      end

      def extract_mapping!(options)
        options.delete_if do |key, value|
          if key.is_a?(String)
            self.rails_path, self.to = key, value
          end
        end
      end

      def split!(options)
        self.spec_options ||= {}
        options.delete_if do |key, value|
          spec_options[key] = value if SPEC_KEYS.include?(key.to_s)
        end
      end

    end
  end
end
