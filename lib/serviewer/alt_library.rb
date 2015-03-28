module Serviewer
  module AltLibrary
    def use_key(k)
      dependancy_library_type = k.split('/')[1].to_sym
      dependancy_name = k.split('/')[2].to_sym

      if fileset_class.alt_library.keys.include?(dependancy_library_type)
        calc_key(fileset_class.alt_library[dependancy_library_type][:library_type],dependancy_name)
      else
        calc_key(dependancy_library_type,dependancy_name)
      end

    end

    def map_alt_library(k,file_hash)
      ek = use_key(k)
      file_hash[ ek ]
    end

  end
end