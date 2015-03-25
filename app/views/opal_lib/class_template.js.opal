module ClassTemplate

    def template(t)
Logger.log("TEMPLATE SET #{self.to_s} ",t)
        `self.$$$template = t`
    end

    def default_template
        t = `self.$$$template`
Logger.log("TEMPLATE GET #{self.to_s} ",t)
        if `typeof t === 'undefined'`
            nil
        else
            return t
        end
    end

end