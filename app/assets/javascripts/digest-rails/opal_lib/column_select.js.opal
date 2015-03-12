class ColumnSelect < Column
    attr_reader :header

    def init( config )
        @header = config[:header]
        @prompt = config[:prompt]
        @click_proc = config[:click_proc]
        return self
    end

    def instance_id
        `self.$$id`
    end

    def html_class
        "#{self.class.to_s}_#{instance_id}"
    end

    def select_links
        Element.find(".#{html_class}")
    end

    def link_proc
        Proc.new do |row, value|
            select_links.on(:click) do |evt|
                if @click_proc.nil?
                    alert "element was clicked"
                else
                    @click_proc.call(evt)
                end
            end
        end
    end

    def data_proc
        Proc.new do |row, value|
<<eos
            <a class="#{html_class} row=#{row}">#{@prompt}</a>
eos
        end
    end

end