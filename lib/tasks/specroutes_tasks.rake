# desc "Explaining what the task does"
# task :specroutes do
#   # Task goes here
# end
namespace :specroutes do
  desc 'Print the current specification in XML to STDOUT'
  task :specification => :environment do
    puts Specroutes.serialize
  end
end
