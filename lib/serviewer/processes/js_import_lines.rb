module Serviewer
  module JsImportLines

    def js_import_lines(content_lines)
      line_number = 1
      content_lines.map do |line|
        export = js_import_from_line(line,line_number)
        line_number += 1
        export
      end.compact
    end

    #import { delay } from 'code/js_lib/1_lib/delay';
    def js_import_from_line(line,line_number)
      tokens = line.strip.split(' ')
      if tokens.length > 6
        tokens.map{ |token| token.strip }
        if tokens[0] == 'import' and
            tokens[1] == '{' and
            tokens[3] == '}' and
            tokens[4] == 'from' then
          {
              symbol: tokens[1],
              key: tokens[4].gsub(';',''),
              line: line_number,
              line_number:line_number
          }
        end
      end
    end

  end
end