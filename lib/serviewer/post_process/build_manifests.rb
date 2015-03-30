module Serviewer
  module BuildManifests

    def build_manifests
      p "Build Manifest"
      @process_map_reason_hash.keys.each do |k|
        @post_process_reason = k
        @post_process_maps = @process_map_reason_hash[k]
        build_manifest_method = "#{k}_build_manifest".to_sym
        self.send( build_manifest_method )
      end
    end

    def default_build_manifest
      p add_indent(@post_process_reason,2)
      build_manifest_line_method = "#{@post_process_reason}_build_manifest_line".to_sym
      @post_process_maps.each_pair do |key,process_map|
        self.send( build_manifest_line_method, process_map )
      end
    end

    def add_indent(ms,indent = 0)
      m = ms.to_s
      s = ""
      (0..indent).each {|ic| s<< ' '}
      s << m
    end

    def to_print_array(h,indent = 0)
      h.keys.map do |k|
        v = h[k]

        if v.is_a? Array
          [ add_indent(k,indent+2), v.map{ |m| add_indent(m,indent+4) } ]
        elsif v.is_a? Hash
          [ add_indent(k,indent+2), to_print_array(v,indent+4) ]
        else
          add_indent("#{k} #{v}", indent + 2 )
        end

      end.flatten
    end

    def print_hash(h,indent = 0)
      to_print_array(h,indent).each do |l|
        p remove_curly_braces(remove_quotes(l))
      end
    end

    def wo_lines ar
      ar.map{ |r| r.delete(:line); r }
    end

    def default_build_manifest_line(process_map)
      file = process_map[:file]
      exceptions = process_map[:exceptions]
      manifest_hash = {}
      h = manifest_hash[ process_map[:file].logical_key ] = {
              gem_name:             process_map[:file].gem_name,
              in:                   process_map[:file].file_path,
              out:                  root_ref( process_map[:output_file_path] )
      }

      if process_map[:rb_require_lines] and process_map[:rb_require_lines].length > 0
        h[:rb_require_lines] = wo_lines( process_map[:rb_require_lines] )
      end

      if process_map[:js_import_lines] and process_map[:js_import_lines].length > 0
        h[:js_import_lines] = wo_lines( process_map[:js_import_lines] )
      end

      if process_map[:js_export_lines] and process_map[:js_export_lines].length > 0
        h[:js_export_lines] = wo_lines( process_map[:js_export_lines] )
      end

      if process_map[:opal_javascript_lines] and process_map[:opal_javascript_lines].length > 0
        h[:opal_javascript_lines] = wo_lines( process_map[:opal_javascript_lines] )
      end

      print_hash( manifest_hash, 4 )
    end

  end
end