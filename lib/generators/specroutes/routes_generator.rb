class Specroutes::RoutesGenerator < Rails::Generators::Base
  def adjust_routes_file
    gsub_file 'config/routes.rb', /(.*::Application)\.routes\.draw/,
      'Specroutes.define(\1.routes)'
  end
end
