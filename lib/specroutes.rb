module Specroutes
  def self.define(rails_router, &block)
    routes = Specroutes::Routing::Routes.new(rails_router)
    routes.draw(&block)
  end

  def self.serialize(serializer=nil)
    serializer ||= Specroutes::Serializer.default_serializer
    serializer.serialize
  end
end

require 'specroutes/railtie'
require 'specroutes/utility_belt'
require 'specroutes/serializer'
require 'specroutes/resource_tree'
require 'specroutes/specification'
require 'specroutes/constraints'
require 'specroutes/routing'
