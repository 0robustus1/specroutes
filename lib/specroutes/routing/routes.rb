module Specroutes::Routing
  class Routes
    include Specroutes::UtilityBelt::DelegateCollector::InstanceMethods
    extend Specroutes::UtilityBelt::DelegateCollector::ClassMethods

    attr_accessor :rails_router

    default_delegate_before { |m| :"before_#{m}" }
    default_delegate_after { |m| :"after_#{m}" }

    hooked_refer_to :get
    hooked_refer_to :post
    hooked_refer_to :put
    hooked_refer_to :delete
    refer_to :resources
    refer_to :resource


    def execute_methods
      this = self
      block = proc do
        this.methods.each { |m| this.execute_method(self, m) }
      end
      rails_router.eval_block(block)
    end

    def execute_method(route_instance, method)
      after = delegate_helper.method_name(after, method[:method], default_delegate_after)
      before = delegate_helper.method_name(before, method[:method], default_delegate_before)
      send(before, *method[:args], &method[:block]) if method[:hooks] && respond_to?(before, true)
      result = route_instance.send(method[:method], *method[:args], &method[:block])
      send(after, result, *method[:args], &method[:block]) if method[:hooks] && respond_to?(after, true)
    end

    def initialize(rails_router)
      self.rails_router = rails_router
    end

    def draw(&block)
      rails_router.clear!
      instance_eval(&block)
      execute_methods
      rails_router.finalize!
      nil
    end

  end
end
