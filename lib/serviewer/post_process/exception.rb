module Serviewer
  module Exception

    def process_exception(c)
      c[:process_map][:exceptions] ||= []
      c[:process_map][:exceptions] << {
          message: [*c[:message]]
      }
    end

    def post_processs_exception(c)
      c[:process_maps].each do |process_map|
        process_exception(
            message: c[:message],
            process_map: process_map
        )
      end
    end

    def print_exception(es,indent= 0)
      es.each do |exception|
        ['EXCEPTION: ', exception[:message]].flatten.each do |m|
          s = ""
          (0..indent).each {|ic| s<< ' '}
          s << m
          p s
        end
      end
    end

  end
end