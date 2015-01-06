namespace :specroutes do
  desc 'Print the current specification in XML to STDOUT'
  task :specification => :environment do
    puts Specroutes.serialize
  end
end
