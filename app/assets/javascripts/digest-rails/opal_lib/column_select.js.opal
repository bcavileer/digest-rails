class ColumnSelect < Column
    attr_reader :header
    attr_writer :table

    class ColumnSelectEvent

        def initialize(event)
            @event = event
        end

        def selected_row_number
            event_current_element
            class_names_string = @event_current_element.class_name
            class_names_array = class_names_string.split(' ')
            row_string = class_names_array[1]
            row_string_s = class_names_array[1].split('_')
            row_number = row_string_s[1]
        end

        def event_current_element
            event_current_targets
            @event_current_element = Element.parse( event_current_targets )
        end

        def event_current_targets
            @event_current_targets = `self.event.$current_target()`
        end

    end

    def init( config )
        @header = config[:header]
        @prompt = config[:prompt]
        @click_proc = config[:click_proc]
        @table = nil
        return self
    end

    def link_proc
        Proc.new do |row, value|
            select_links.css 'color', 'blue'

            select_links.on(:click) do |event|

                @event = ColumnSelectEvent.new(event)
                @event.event_current_element.css 'color', 'red'

                row_number = @event.selected_row_number
                row_content = @table.get_row_content( row_number ) if !@table.nil?

                if @click_proc.nil?
                    alert "Row #{row_number} was clicked"
                else
                    @click_proc.call(row_number,row_content)
                end

            end
        end
    end

    def data_proc
        Proc.new do |row, value|
<<eos
            <a class="#{html_class} row_#{row}">#{@prompt}</a>
eos
        end
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

end