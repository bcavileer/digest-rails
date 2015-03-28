module Serviewer
  module RequireLines

    def require_lines(content_lines)
      line_number = 1
      content_lines.map do |line|
        require = require_from_line(line,line_number)
        line_number += 1
        require
      end.compact
    end

    def require_from_line(line,line_number)
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


