module Specroutes
  class Specification
    attr_accessor :rails_router

    def self.registered_specification
      if Rails.application.config.
        respond_to?(:specroutes_registered_specification)
        Rails.application.config.specroutes_registered_specification
      end
    end

    def initialize(rails_router)
      self.rails_router = rails_router
    end

    def register_with_application
      Rails.application.config.specroutes_registered_specification = self
    end

    def register(route_specification)
      resources << route_specification
    end

    def resource_tree
      @resource_tree ||= ResourceTree.from_resource_list(resources)
    end

    def resources
      @resources ||= []
    end
  end
end
