require 'specroutes/serializer/xml'

module Specroutes
  module Serializer
    DEFAULT = Specroutes::Serializer::XML

    def self.default_serializer
      DEFAULT.new(Specroutes::Specification.registered_specification)
    end
  end
end
