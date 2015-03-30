module Serviewer
  module GetOpalJavascriptLines
    def get_opal_javascript_lines(content_lines)
      result = []
      each_content_line(content_lines) do |line,line_number|
        result << if /\`/ =~ line
          {
              line_number: line_number,
              line: line
          }
        else
          nil
        end
      end
      return result.compact
    end
  end
end