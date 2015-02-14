class EndpointRouteFix < ActiveRecord::Migration
  rename_column 'digest_rails_digests', "path_repl_command", "engine"
  rename_column 'digest_rails_digests', "url_subdomain", "route_name"
end
