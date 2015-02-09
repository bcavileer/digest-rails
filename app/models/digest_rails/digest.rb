module DigestRails
  class Digest < ActiveRecord::Base
    attr_accessible :key,:menu_name_high,:menu_index_high,:menu_name_med,:menu_index_med,:menu_name_low,:menu_index_low
    attr_accessible :data, :data_length
    attr_accessible :url_subdomain, :path_repl_command
  end
end
