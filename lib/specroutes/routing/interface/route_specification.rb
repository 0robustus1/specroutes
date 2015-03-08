module Specroutes::Routing
  module Interface
    class RouteSpecification
      SPEC_KEYS = %w(doc docs)

      attr_accessor :rails_path, :method, :to
      attr_accessor :query_params
      attr_accessor :options, :spec_options
      attr_accessor :meta

      def initialize(method, args, &block)
        self.method = method
        self.options = prepare_options!(args.extract_options!)
        self.rails_path = args.first if args.any?
        split_rails_path!
        self.meta = MetaDataDSL.new(self, &block)
      end

      def register(specification)
        specification.register(self)
      end

      def on_match_calls(&block)
        meta.reroutes.each do |reroute|
          opts = altered_match_options(reroute[:target],
                                       reroute[:constraint])
          block.call(opts, meta.match_block)
        end
        block.call(match_options, meta.match_block)
      end

      def match_options
        if to
          [options.merge(via: method).merge(rails_path => to)]
        else
          [rails_path, options.merge(via: method)]
        end
      end

      def altered_match_options(target, constraint)
        opts = options.merge(via: method, rails_path => target)
        opts.delete(:controller)
        opts.delete(:action)
        opts.delete(:to)
        opts[:constraints] = altered_constraints(constraint)
        [opts]
      end

      def altered_constraints(constraint)
        group = maybe_group(options[:constraints])
        if group
          group.dup.prepend!(constraint)
        else
          constraint
        end
      end

      def path
        rails_path.gsub(/[:*]([^\/]+)/, '{\1}')
      end

      def identifier
        ":#{method.upcase}:#{rails_path}"
      end

      def define_constraints
        if query_params.present?
          qp_klass = Specroutes::Constraints::QueryParamConstraint
          if key_val_params.present?
            add_to_constraints!(qp_klass.new(key_val_params))
          end
          pp_klass = Specroutes::Constraints::PositionalParamConstraint
          if positional_params.present?
            add_to_constraints!(pp_klass.new(positional_params))
          end
        else
          options[:constraints] = maybe_group(options[:constraints])
        end
        add_possible_mime_constraints!
      end

      def add_possible_mime_constraints!
        if meta.mime_constraints.any?
          group = meta.mime_constraints.group_by { |(_mime, allstar)| allstar }
          add_possible_mime_constraints_from_group!(group, false)
          add_possible_mime_constraints_from_group!(group, true)
        end
      end

      def add_possible_mime_constraints_from_group!(group, allstar)
        if group[allstar] && group[allstar].any?
          mimes = group[allstar].map { |el| el.first }
          mt_klass = Specroutes::Constraints::MimeTypeConstraint
          add_to_constraints!(mt_klass.new(*mimes, accept_allstar: allstar))
        end
      end

      def docs
        docs =
          if spec_options[:doc].is_a?(Hash)
            [spec_options[:doc]]
          else
            Array(spec_options[:doc])
          end
        docs + Array(spec_options[:docs]) + meta.docs.values
      end

      def key_val_params
        params = []
        query_params.present? and query_params.map do |param|
          key, val = param.split('=', 2)
          params << key if val
        end
        params
      end

      def positional_params
        pos = 0
        query_params.present? and query_params.reduce({}) do |h, param|
          key, val = param.split('=', 2)
          h[key] = pos unless val
          pos += 1
          h
        end
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
