require 'digest-rails/opal_lib/base_section_controller'
`console.log('class PaneController')`

class PaneController < BaseSectionController
    attr_accessor :pane_header, :pane_body, :pane_footer
    attr_accessor :column_0, :column_1, :column_2, :column_3

    class HeaderController < BaseSectionController
        template Template['digest-rails/views/pane_header']
    end

    class ColumnController < BaseSectionController
        template Template['digest-rails/views/column']
    end

    class FooterController < BaseSectionController
        template Template['digest-rails/views/pane_footer']
    end

    def self.boot(c)
        self.new(c.merge(name: :pane)).scope do |pane,context|

            pane.pane_header = HeaderController.new( name: :pane_header, context: context )

            context.push(name: :pane_body) do |pane_body|
                pane_body.push(name: :row) do |row|
                    pane.column_0 = ColumnController.new( name: :column_0, context: row )
                    pane.column_1 = ColumnController.new( name: :column_1, context: row )
                    pane.column_2 = ColumnController.new( name: :column_2, context: row )
                    pane.column_3 = ColumnController.new( name: :column_3, context: row )
                end
            end

            pane.pane_footer = FooterController.new( name: :pane_footer, context: context)
        end
    end

end
