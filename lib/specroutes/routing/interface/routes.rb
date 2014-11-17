module Specroutes::Routing
  module Interface
    module Routes

      def specified_get(path, options)
        specified_match(path, options.merge!(method: 'get'))
      end

      def specified_post(path, options)
        specified_match(path, options.merge!(method: 'post'))
      end

      def specified_put(path, options)
        specified_match(path, options.merge!(method: 'put'))
      end

      def specified_delete(path, options)
        specified_match(path, options.merge!(method: 'delete'))
      end

      def specified_match(path, options)
        standard_path, query_path = path_portions(path)
        standard_opt, spec_opts = option_portions(path)
        spec = RouteSpecification.new(path, options)
        match(standard_path, standard_opt)
        match(*spec.match_options)
        spec.define_constraints
        spec.register(specification)
      end

    end
  end
end
