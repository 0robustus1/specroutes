module Specroutes::Routing
  class Routes
    include Specroutes::Routing::Interface::Routes

    attr_accessor :rails_router, :specification

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
