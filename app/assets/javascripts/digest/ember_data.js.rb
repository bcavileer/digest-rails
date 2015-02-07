//= require 'opal-paloma'

module Paloma
  class EmberData
    def initialize(name)
      @name = name
      return self
    end

    def get_promise()
      `console.log('requested: ' + this['name'] );`
      cmd = <<-EOS
        this['deferred'] = new jQuery.Deferred();
        this['promise'] = this['deferred'].promise(
          $.ajax({
            dataType: "json",
            url: "#{href}",
            success: self.$fetched.bind(self)
          })
        );
      EOS
      `eval(cmd)`
      return @promise
    end

    def href
      cmd = "this[\"href\"] = $(\"div#data_links a.#{@name}\").attr(\"href\");"
      `eval(cmd)`
      return @href
    end

    def fetched(data)
      digest_name_raw = `data.digest.name;`
      decoded = Paloma::DigestDecode.new.decode(digest_name_raw,data)
      `console.log('decoded: ' + decoded.name);`

      digest = Paloma::Digest.new(decoded).process
      `console.log('digest: ' + decoded.name + ' > ' + digest);`

      result = {
          :name => @name,
          :digest => digest
      }
      `this['deferred'].resolve(result);`
    end

  end
end