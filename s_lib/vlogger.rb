class VLogger

    def log(text,object=nil)
        if object.nil?
            puts text
        else
            puts "#{text} #{object}"
        end
    end

end
