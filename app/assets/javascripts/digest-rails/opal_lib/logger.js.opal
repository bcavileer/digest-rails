`console.log('class Logger')`

class Logger

    def log(text,object=nil)
        if object
            `console.log(text,object)`
        else
            `console.log(text)`
        end
    end

end
