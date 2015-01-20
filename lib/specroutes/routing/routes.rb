module Specroutes::Routing
  class Routes
    include Specroutes::UtilityBelt::DelegateCollector::InstanceMethods
    extend Specroutes::UtilityBelt::DelegateCollector::ClassMethods
    include Specroutes::Routing::Interface::Routes

    attr_accessor :rails_router, :specification

    default_delegate_before { |m| :"before_#{m}" }
    default_delegate_after { |m| :"after_#{m}" }

    hooked_refer_to :get
    hooked_refer_to :post
    hooked_refer_to :put
    hooked_refer_to :delete
    refer_to :resources
    refer_to :resource
    refer_to :namespace
    refer_to :match
    refer_to :root
    refer_to :collection
    refer_to :member


    def execute_methods
      this = self
      block = proc { this.methods.each { |m| this.execute_method(self, m) } }
      rails_router.eval_block(block)
    end

    def execute_method(route_instance, method)
      before, after = callbacks(method)
      send_call(method, method_name: before) if hook_callable?(method, before)
      result = send_call(method, to: route_instance)
      send_call(method, result, method_name: after) if hook_callable?(method, after)
    end

    def callbacks(method, before: nil, after: nil)
      after_callback = delegate_helper.
        method_name(after, method[:method], default_delegate_after)
      before_callback = delegate_helper.
        method_name(before, method[:method], default_delegate_before)
      [before_callback, after_callback]
    end

    def send_call(method, *added_args, method_name: method[:method], to: self)
      to.send(method_name, *method[:args], *added_args, &method[:block])
    end

    def hook_callable?(method, method_name, to: self)
      method[:hooks] && to.respond_to?(method_name, true)
    end

    def initialize(rails_router)
      self.rails_router = rails_router
      self.specification = Specroutes::Specification.new(rails_router)
    end

    def draw(&block)
      rails_router.clear!
      instance_eval(&block)
      rails_router.finalize!
      specification.register_with_application
      nil
    end

    private
    def method_missing(method_name, *args, &block)
      if mapper.respond_to?(method_name)
        mapped_exec { send(method_name, *args, &block) }
      else
        raise NoMethodError.new <<-ERR
#{method_name} is neither defined for #{self.class} nor for #{mapper.class}.
        ERR
      end
    end

    def mapped_exec(&block)
      if rails_router.default_scope
        mapper.with_default_scope(rails_router.default_scope, &block)
      else
        mapper.instance_exec(&block)
      end
    end

    def mapper
      @mapper ||= ActionDispatch::Routing::Mapper.new(rails_router)
    end

  end
end
