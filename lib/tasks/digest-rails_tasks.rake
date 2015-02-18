namespace :old do
  desc 'all named routes with as_mounted subdomains'
  task :routes_as_mounted => :environment do
    require 'axle/route/dir'
    Axle::Route::Dir.engine_map(:old).each_pair do |engine_name,path|
      p "#{engine_name} => #{path}"
    end
  end
end
