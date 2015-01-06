module Specroutes
  class Railtie < Rails::Railtie
    railtie_name :specroutes

    rake_tasks do
      load "tasks/specroutes_tasks.rake"
    end
  end
end
