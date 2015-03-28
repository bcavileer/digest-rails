module Serviewer
  module OpalJavascriptLines

    def opal_javascript_lines(content_lines)
      line_number = 1
      r = content_lines.map do |line|
        r = if /\`/ =~ line
              r = {
                  line_number: line_number,
                  line: line
              }
              r
            else
              nil
            end
        line_number += 1
        r
      end.compact
    end
  end
end