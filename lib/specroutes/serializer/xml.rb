require 'xml'

module Specroutes::Serializer
  class XML
    attr_accessor :specification

    def initialize(specification)
      self.specification = specification
    end

    def serialize
      doc = ::XML::Document.new
      define_application(doc) do |app|
        define_resources(app, base: '/') do |resources_el|
          specification.resources.each { |r| define_resource!(resources_el, r) }
        end
      end
      doc.to_s
    end

    def define_application(document)
      application_el = ::XML::Node.new('application')
      document.root = application_el
      yield application_el if block_given?
    end

    def define_resources(application_el, base:)
      resources_el = ::XML::Node.new('resources')
      resources_el['base'] = base
      application_el << resources_el
      yield resources_el if block_given?
    end

    def define_resource!(resources_el, resource)
      resource_el = ::XML::Node.new('resource')
      resource_el['path'] = resource.path
      define_method!(resource_el, resource)
      resources_el << resource_el
    end

    def define_method!(resource_el, resource)
      method_el = ::XML::Node.new('method')
      method_el['name'] = resource.method
      method_el['id'] = resource.identifier
      resource_el << method_el
    end
  end
end
