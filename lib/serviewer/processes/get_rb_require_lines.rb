module Serviewer
  module GetRbRequireLines

    def get_rb_require_lines( content_lines )
      map_tokenized_lines(content_lines) do | tokens, line, line_number |
        tokens.length > 1 ? require_from_line( tokens, line, line_number ) : nil
      end
    end

    def require_from_line( tokens, line, line_number )
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
