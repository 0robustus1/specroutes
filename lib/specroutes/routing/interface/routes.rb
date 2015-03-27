module Specroutes::Routing
  module Interface
    module Routes
      def specified_resource_part(path)
        resource_part = ResourcePart.new(path)
        @resource_part_stack ||= []
        @resource_part_stack.push(resource_part)
        yield(resource_part)
        @resource_part_stack.pop
      end

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

      def specified_match(method, *args, &block)
        spec = RouteSpecification.new(method, args, current_stack, &block)
        spec.define_constraints
        spec.on_match_calls do |match_options, match_block|
          match(*match_options, &match_block)
        end
        spec.register(specification)
      end

      private
      def current_stack
        @resource_part_stack ? @resource_part_stack.dup : []
      end
    end
  end
end
