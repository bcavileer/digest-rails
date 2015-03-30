module Serviewer
  module Lexical

    def remove_quotes(s)
      s.gsub("\"",'').gsub("\'",'')
    end

    def remove_curly_braces(s)
      s.gsub("{",'').gsub("}",'')
    end

    def map_tokenized_lines(content_lines)
      result = []
      each_content_line(content_lines) do |line, line_number|
        result << ( yield clean_tokens(raw_tokens(line)), line, line_number )
      end
      result.flatten.compact
    end

    def raw_tokens(line)
      line.strip.split(' ')
    end

    def clean_tokens(raw_tokens)
      raw_tokens.map do |t|
        t = remove_quotes(t)
        t.gsub("\n",'').gsub(";",'')
      end
    end

    def each_content_line(content_lines)
      line_number = 1
      content_lines[0..19].each do |line|
        yield line, line_number
        line_number += 1
      end
    end

  end
end