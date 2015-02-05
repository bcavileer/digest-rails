module Paloma
  class Controller

    class << self

      def create(klass, names, methods)
        n = new(klass, names, methods).construct
        n.add_instance_methods
        return n
      end

      def create_controller(names, methods)
        opal_controller = create(self, names, methods)
        return `opal_controller.constructor`
      end

    end

    def initialize(klass, names, methods)
      @klass = klass
      @controllerPath = names
      @methods = methods
    end

    def construct
      namespace
      cmd = "#{logical} = this.$do_construct(\"#{route}\") "
      @constructor = `eval(cmd)`
      return self
    end

    def add_instance_methods
      @methods.each do |m|
        cmd = "#{prototype_method_name(m)} = Opal.#{logical}.$#{m}"
        `eval(cmd)`
      end
    end

    def logical
      @controllerPath[0] + '.' + @controllerPath[1] + '.' + @controllerPath[2]
    end

    def route
      @controllerPath[0] + '/' + @controllerPath[1] + '/' + @controllerPath[2]
    end

    def prototype_method_name(mname)
      "self[\'constructor\'].prototype.#{mname}"
    end

    def do_construct(a_route)
      `Paloma.controller(a_route)`
    end

    def defined(name)
      var_value = `eval(name)`
      return `(typeof var_value != 'undefined')`
    end

    def namespace
      if !defined(@controllerPath[0])
        cmd = "#{@controllerPath[0]} = {}"
        `eval(cmd)`
      end
      next_dir = "#{@controllerPath[0]}.#{@controllerPath[1]}"
      if !defined(next_dir)
        cmd = "#{next_dir} = {}"
        `eval(cmd)`
      end
    end

  end
end