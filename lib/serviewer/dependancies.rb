module Serviewer

  module Dependancies
    attr_accessor :dependancy_order, :dependancy_map

    def init_dependancies
      @dependancy_order = nil
      dependancy_map
    end

    def to_key(require_ref)
      require_ref.gsub("\"",'').gsub("\'",'')
    end

    def dependancy_map
      @dependancy_map ||= content_lines.inject({}) do |hr,line|
        if require = require_from_line(line)
          hr[ require[:rkey] ] = nil
        end
        hr
      end
    end

    def require_from_line(line)
      tokens = line.strip.split(' ').map{ |token| token.strip }
      if tokens[0] == 'require'
        {
            rkey: to_key( tokens[1] ),
            line: line
        }
      else
        nil
      end
    end

    def map_dependancies(file_hash)
      dependancy_map.keys.each do |k|
        dependancy_map[k] = map_alt_library(k,file_hash)
      end
    end

    def unscheduled_at_last_iteration(dependancy,this_iteration)
      dependancy.dependancy_order.nil? or dependancy.dependancy_order == this_iteration
    end

    def unscheduled_dependancies_at_last_iteration( this_iteration )
      dependancy_map.values.inject([]) do |a,dependancy|
        if dependancy and unscheduled_at_last_iteration(dependancy, this_iteration)
          a << dependancy
        end
        a
      end
    end

    def report_dependancy_mapped_to_nil
      any = false
      dependancy_map.keys.each do |k|
        if dependancy_map[k].nil?
          if !any
            p description
            any = true
          end
          p "    dependancy #{k} not mapped"
          p " "
        end
      end
    end

    def report_dependancy_order_nil
      if self.dependancy_order.nil?
        p description
        p "    dependancy_order is nil"
        self.dependancy_map.each_pair do |key,mapped_to|
          p "      #{key} => #{mapped_to ? mapped_to.key : 'NIL'}  #{mapped_to ? mapped_to.dependancy_order : ''} "
        end
        p " "
      end
    end

  end
end