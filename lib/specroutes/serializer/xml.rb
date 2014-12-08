require 'xml'

module Specroutes::Serializer
  class XML
    attr_accessor :specification

    DATATYPE_MAPPING = {
      string: 'xsd:string',
      boolean: 'xsd:boolean',
      bool: 'xsd:boolean',
      double: 'xsd:double',
      float: 'xsd:float',
      int: 'xsd:int',
      integer: 'xsd:integer',
      long: 'xsd:long',
    }

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
      define_params!(method_el, resource)
      resource_el << method_el
    end

    def define_params!(method_el, resource)
      resource.query_params.each { |q| define_param!(method_el, q) }
    end

    def define_param!(method_el, query_param)
      param, value = query_param.split('=')
      param_el = ::XML::Node.new('param')
      param_el['name'] = param
      if value
        param_el['style'] = 'query'
        param_el['type'] = typefy_to_xsd(value)
      else
        param_el['style'] = 'positional'
      end
      method_el << param_el
    end

    def typefy_to_xsd(value)
      if value.start_with?('xsd:')
        value
      else
        DATATYPE_MAPPING[value.to_sym] ||
          raise(Errors::UnknownDatatypeError.new(value))
      end
    end
  end
end
