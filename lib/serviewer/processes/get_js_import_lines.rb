module Serviewer
  module GetJsImportLines

    def get_js_import_lines(content_lines)
      map_tokenized_lines(content_lines) do |tokens, line, line_number|
        tokens.length > 5 ? js_import_from_line(tokens, line, line_number) : nil
      end
    end

    #import { delay } from 'code/js_lib/1_lib/delay';
    def js_import_from_line(tokens, line, line_number)
        if tokens[0] == 'import' and
            tokens[1] == '{' and
            tokens[3] == '}' and
            tokens[4] == 'from' then
          {
            local_symbol: tokens[2],
            logical_key: tokens[5].gsub(';',''),
            line: line,
            line_number: line_number
          }
        end
    end

  end
end