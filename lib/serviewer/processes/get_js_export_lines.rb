module Serviewer
  module GetJsExportLines

    def get_js_export_lines(content_lines)
      map_tokenized_lines(content_lines) do |tokens, line, line_number|
        tokens.length >= 3 ? js_export_from_line(tokens,line_number) : nil
      end
    end

    #export class MarkupControllerFactory {
    def js_export_from_line(tokens,line_number)
      if tokens[0] == 'export' then
        {
            type: tokens[1],
            symbol: tokens[2]
        }
      end
    end
  end
end
