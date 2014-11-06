module Specroutes::UtilityBelt
  module DelegateCollector
    module InstanceMethods
      def default_delegate_before(&block)
        if block
          self.class.instance_variable_set(:@interim_delegate_before, block)
        else
          self.class.instance_variable_get(:@interim_delegate_before)
        end
      end

      def default_delegate_after(&block)
        if block
          self.class.instance_variable_set(:@interim_delegate_after, block)
        else
          self.class.instance_variable_get(:@interim_delegate_after)
        end
      end

      def delegate_helper
        Helper
      end

      def append_to_methods(hooks: false, method:, args: [], block: nil)
        @methods ||= []
        @methods << {method: method, hooks: hooks, args: args, block: block}
      end

      def methods
        @methods ||= []
      end
    end

    module ClassMethods
      def default_delegate_before(&block)
        if block
          instance_variable_set(:@interim_delegate_before, block)
        else
          instance_variable_get(:@interim_delegate_before)
        end
      end

      def default_delegate_after(&block)
        if block
          instance_variable_set(:@interim_delegate_after, block)
        else
          instance_variable_get(:@interim_delegate_after)
        end
      end

      def hooked_refer_to(method)
        define_method(method) do |*args, &block|
          append_to_methods(hooks: true, method: method,
                            args: args, block: block)
        end
      end

      def refer_to(method)
        define_method(method) do |*args, &block|
          append_to_methods(hooks: false, method: method,
                            args: args, block: block)
        end
      end
    end

    module Helper
      def self.method_name(explicit, method, default_block)
        if explicit
          explicit
        else
          default_block.call(method)
        end
      end
    end
  end
end
