module Specroutes::Routing
  module Interface
    module Routes

      def specified_get(*args, &block)
        specified_match('get', *args, &block)
      end

      def specified_post(*args, &block)
        specified_match('post', *args, &block)
      end

      def specified_put(*args, &block)
        specified_match('put', *args, &block)
      end

      def specified_delete(*args, &block)
        specified_match('delete', *args, &block)
      end

      def specified_match(method, *args, &_block)
        spec = RouteSpecification.new(method, args)
        match(*spec.match_options)
        spec.define_constraints
        spec.register(specification)
      end

    end
  end
end
