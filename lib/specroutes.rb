module Specroutes
  def self.define(rails_router, &block)
    routes = Specroutes::Routing::Routes.new(rails_router)
    routes.draw(&block)
  end
end

require 'specroutes/utility_belt'
require 'specroutes/specification'
require 'specroutes/routing'
