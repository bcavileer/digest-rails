module Serviewer
  module JsExportLines

    def js_export_lines(content_lines)
      line_number = 1
      content_lines.map do |line|
        export = js_export_from_line(line,line_number)
        line_number += 1
        export
      end.compact
    end

    #export class MarkupControllerFactory {
    def js_export_from_line(line,line_number)
      tokens = line.strip.split(' ')
      if tokens.length > 1
        tokens.map{ |token| token.strip }
        if tokens[0] == 'require'
          {
              require_ref: tokens[1],
              line: line
          }
        else
          nil
        end
      end
    end
  end
end




