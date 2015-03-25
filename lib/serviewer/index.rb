#
# From File: views/ruby_lib/class_template Order: 1
#
module ClassTemplate

    def template(t)
    end

    def default_template
    end

end
#
# From File: views/poly_lib/cell Order: 1
#
class Cell
    attr_accessor :property, :data

    def initialize(column)
        @column = column
        @property = {}
    end

    def property_data
        @property[:data] = @column.data_proc
        return @property
    end

    def for_row(i)
        @data = property_data[:data].call(i,nil)
        return self
    end

    def rendering
        @rendering = @data
    end

end
#
# From File: views/poly_lib/router Order: 1
#
`console.log('class Router')`

class Router



    def route_js(user_request)
        Logger.log('route_js', user_request)
        return route( UserRequest.new( Native(user_request) ) )
    end

    def route(user_request)
        Logger.log("route to #{user_request.digest_name}:",user_request)
        @user_request = user_request
        return new_controller
    end

    def new_controller
        controller_class = "#{@user_request.digest_name.capitalize}PaneController"
        opal_class = `Opal.get(controller_class)`
        return `opal_class.$new( self.$controller_params() )`
    end

    def controller_params
        {
            user_request: @user_request,
            name: @user_request.digest_name
        }
    end

end
#
# From File: views/poly_lib/column Order: 1
#
class Column

    def header
        @header
    end

    def data_proc
        me = self

        Proc.new do |row, value|
            # Assumes READ (value == nil)
            'Column Base Class - OVERRIDE'
        end

    end

    def inspect_lines
        r = []
        r << "aaa#{self.class}"
        return r
    end

end
#
# From File: views/poly_lib/render_target Order: 1
#

class RenderTarget
    attr_reader :selector

    def initialize(c)
        @selector = c[:selector]
    end

    def under_render_target(parent)
        return self.class.new(
            "#{parent.selector} > #{selector}"
        )
    end

    def append(txt)
        `$(self.selector).append(txt)`
    end

    def select
        `$(self.selector)`
    end

    def html(txt)
        `$(self.selector).html(txt)`
    end

end
#
# From File: views/poly_lib/render_context Order: 1
#
class RenderContext < Hash
    attr_accessor :name, :dir, :parent
    
    def initialize(c)
        @dir = c[:dir]
        @root = c[:root]
        @root ||= false

        @name = c[:name]
        @parent = c[:parent]
        super { |hash, key| hash[key] = [] }
    end

    def point_context
        self
    end

    def open_struct
        os = OpenStruct.new( flattened_context )
    end

    def flattened_context
        @dir.flattened_context( self.clone )
    end

    def fullname
        [ ( @root ? nil : @parent.fullname ), name ].compact.join('__')
    end

    def ancestory
        [ ( @root ? nil : @parent ), self ].compact.flatten
    end

    def pop
        return @parent
    end

    def push_name(n)
        push(name: n)
    end

    def push(c)
        c[:dir] = @dir
        c[:parent] = self

        new_cursor = @dir.push( RenderContext.new(c) )

        if block_given?
            yield new_cursor
            new_cursor.pop
        else
            return new_cursor
        end

    end

    def chain(key)
        rr = chain_raw(key)
        return rr.compact.reverse.flatten
    end

    def chain_raw(key,r=[])
        r ||= []
        fetch_key_value = nil
        begin
            r << self.fetch(key)
        rescue
        end

        if !@root
            @parent.chain_raw(key,r)
        else
            r
        end
    end

    def [](key)
        value = super(key)
        if value.nil?
            value = if !@root
                parent.get(key)
            end
        end
        return value
    end

    # JS call
    alias_method :get,:[]

    # JS call
    alias_method :set_key_value,:[]

end
#
# From File: views/poly_lib/render Order: 1
#
module Render
    def render(c = nil)

Logger.log('render 1',self)

        context = get_context
        context = c[:context] if c and c[:context]

Logger.log('render 2',self)

        template = self.class.default_template

        # TODO Clean up context where errant template is
        # @template = @context[:template] if @context[:template]

        template = c[:template] if c and c[:template]

Logger.log('render 3',self)

        text = context[:text]
        text = c[:text] if c and c[:text]

        context[:text] = text if text

        html = if template.nil?
            text
        else
            template.render( context.open_struct )
        end

Logger.log('self',self)
Logger.log('get_context',get_context)
Logger.log('render_target',get_render_target)
Logger.log('html',html)

        get_render_target.html(html)
    end
end
#
# From File: views/poly_lib/quick_html_table Order: 1
#

#################################
# QUICK HTML table
#################################
module QuickHtmlTable
        def tag_open n
            "<#{n.to_s}>"
        end

        def tag_close n
            "</#{n.to_s}>"
        end

        def table
            @r << tag_open(:TABLE)
            yield
            @r << tag_close(:TABLE)
        end

        def row
            @r << tag_open(:TR)
            yield
            @r << tag_close(:TR)
        end

        def column_header
            @r << tag_open(:TH)
            yield
            @r << tag_close(:TH)
        end

        def cell
            @r << tag_open(:TD)
            yield
            @r << tag_close(:TD)
        end

        def h2
            @r << tag_open(:H2)
            yield
            @r << tag_close(:H2)
        end
end
#
# From File: views/poly_lib/markup_links Order: 1
#
class MarkupLinks

    def initialize
        @link_procs = []
    end

    def add_link_proc(link_proc)
        @link_procs<< link_proc
    end

    def run_link_procs
        @link_procs.each do |link_proc|
            link_proc.call()
        end
        @link_procs  = []
    end

end
#
# From File: views/poly_lib/controller_context_local Order: 1
#
class ControllerContextLocal

    attr_reader :render_target_absolute, :render_target_relative

    def init(config)
        @name = config[:name]
        raise "ControllerContext requires name" if @name.nil?
        @source_context = config[:source_context]
        @context = @source_context.get.push(name: @name)
        set_context_value( :controller, config[:controller] )
        set_render_target( config[:selector] )
        return self
    end

    def set_render_target(config_selector)

 Logger.log('config_selector',config_selector)
 Logger.log('name',@name)

        if config_selector
            if config_selector.include?('#')
                    @render_target_absolute =
                    set_context_value( :render_target_absolute, RenderTarget.new( selector: config_selector ) )
            else
                @render_target_relative =
                    set_context_value( :render_target_relative, RenderTarget.new( selector: config_selector ) )
            end
        else
            @render_target_relative =
                set_context_value( :render_target_relative, RenderTarget.new( selector: ".#{@name}" ) )
        end
    end

    def get
        client_context_dir.list[client_context_fullname]
    end

    private

    def set_context_value(value_key, value)
        client_context_dir.set_context_value_key(
            client_context_fullname,
            value_key,
            value
        )
    end

    def client_context_dir
        @source_context.get.dir
    end

    def client_context_fullname
        @context.fullname
    end

end
#
# From File: views/poly_lib/controller_render_target Order: 1
#
class ControllerRenderTarget

    def init(c)
        @configuration = c[:configuration]
        @source_context = c[:source_context]
        @controller_context = c[:controller_context]
        return self
    end

    def get
        RenderTarget.new(selector: selector)
    end

    private

    def selector
        render_target_selectors.join(' > ')
    end

    def render_target_selectors
        render_target_array.map do |rt|
            rt.selector
        end
    end

    def render_target_array
        hit_absolute = false
        render_targets = []
        @controller_context.get.ancestory.map do |ctx|
            Logger.log("ctx: ",ctx)
            if !hit_absolute
                rta = ctx[:render_target_absolute]
                rtr = ctx[:render_target_relative]
                if rta and rtr
                    Logger.log("Context with RenderTarget issue: ",ctx)
                    raise "Context can have only only one RenderTarget with a relative OR absolute selector"
                end
                render_targets << rta
                render_targets << rtr
                hit_absolute = true if rta
             end
        end.compact.flatten
    end

 end
#
# From File: views/poly_lib/row Order: 1
#
class Route

    def initialize
    end

    def render(user_request)
    end
end
#
# From File: views/poly_lib/user_request Order: 1
#
#
# From File: views/poly_lib/controller_source_context Order: 1
#
class ControllerSourceContext

    def init(config)
        @defined_context = config[:context]
        return self
    end

    def get
        ( @defined_context ? @defined_context : ::ClientContext.references[:first_cursor] )
    end

end
#
# From File: views/poly_lib/hot_like_table Order: 2
#
# Processed Require Line: require 'digest-rails/poly_lib/cell'

module HotLikeTable

   def render_table(config)
        #@rows = config[:rows]
        #@rows ||= :all

        table do
            render_header
            render_rows
        end
    end

    def render_header
        row do
            colHeaders.each do |colHeader|
                column_header do
                    @r << colHeader
                end
            end
        end
    end

    def row_range
        if @rows == :all
            (0..data.length-1)
        else
            [ @rows.to_i ]
        end
    end

    def render_rows
        row_range.each do |i|
            render_row(i)
        end
    end

    def render_row(i)
        row do
            @data_source.columns.each do |column|
                cell do
                    cell_content = Cell.new(column).for_row(i)
                    @rendering_data << {
                        data: cell_content.data,
                        column: column
                    }
                    @r << cell_content.rendering
                end
            end
        end
    end

end
#
# From File: views/poly_lib/controller_context Order: 2
#
# Processed Require Line: require 'digest-rails/poly_lib/controller_source_context'
# Processed Require Line: require 'digest-rails/poly_lib/controller_context_local'
# Processed Require Line: require 'digest-rails/poly_lib/controller_render_target'

module ControllerContext

    def initialize(c)
        raise 'Controller instance name required (ie dialog_0)' if !c[:name]
        @source_context = SourceContext.new.init(c)

        @controller_context = ControllerContextLocal.new.init(
            name: c[:name],
            selector: c[:selector],
            controller: self,
            source_context: @source_context
        )

        @controller_render_target = ControllerRenderTarget.new.init(
            config: c,
            source_context: @source_context,
            controller_context: @controller_context
        )
    end

    def scope
        yield self, @controller_context.get
        return self
    end

    def get_render_target
        @controller_render_target.get
    end

    def get_context
        @controller_context.get
    end

end
#
# From File: views/poly_lib/table Order: 2
#
# Processed Require Line: require 'digest-rails/poly_lib/column'

class Table
    include HotHelpers
    include HotLikeTable
    include QuickHtmlTable
    include DigestHelpers

    def initialize( name, data_source )
        @name = name
        @data_source = data_source
    end

    def data
        @data_source.data
    end

    def render(config={})
        @rows = config[:rows]
        @rows ||= :all

        @r = []
        @rendering_data = []

        @data_source.columns.each do |column|
            column.table = self if column.respond_to?(:table=)
        end

        h2{ @r << @name }
        render_table( config )
        add_link_procs

        @rendering = @r.join
    end

    def get_row_content(row_number)
        render( rows: row_number )
        return ({
            rendering: @rendering,
            data: @rendering_data
        })
    end

    def add_link_procs
        @data_source.columns.each do |column|
            MarkupLinks.add_link_proc(column.link_proc) if column.respond_to? :link_proc
        end
    end

end
#
# From File: views/poly_lib/column_text Order: 2
#
# Processed Require Line: require 'digest-rails/poly_lib/column'
class ColumnText < Column
    attr_reader :header, :data_proc

    def init(config)
        @header = config[:header]
        @text = config[:text]

        return self
    end

    def data_proc
        Proc.new do |row, value|
            @text
        end\
    end

end
#
# From File: views/poly_lib/column_select Order: 2
#
# Processed Require Line: require 'digest-rails/poly_lib/column'
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
#
# From File: views/poly_lib/column_indirect_attr Order: 2
#
# Processed Require Line: require 'digest-rails/poly_lib/column'
#require 'axle/poly_lib/digest_helpers'

class ColumnIndirectAttr < Column
    attr_reader :header, :core_model_name, :core_attr, :identifier_model_name

    def init( config )

        @header                 = config[:header]

        @core_model_name        = config[:core_model]
        @core_attr              = config[:core_attr]

        @identifier_model_name  = config[:identifier_model]

        return self
    end

    def data_proc

        Proc.new do |row, value|
            # Assumes READ (value == nil)

            id_val = Store.data_proc_model(
                model: @core_model_name,
                attr: @core_attr
            ).call(row, nil)

            final_val = Store.data_proc_identifier(
                model: @identifier_model_name,
                attr: :name
            ).call(id_val, nil)
        end

    end

end
#
# From File: views/poly_lib/column_direct_attr Order: 2
#
#require 'axle/poly_lib/digest_helpers'
# Processed Require Line: require 'digest-rails/poly_lib/column'

class ColumnDirectAttr < Column
    attr_reader :header, :model, :header

    def init( config )

        @header     = config[:header]

        @model      = config[:model]
        @attr       = config[:attr]


        return self
    end

    def data_proc
        # Proc |row, value|
        Store.data_proc_model(
            model: @model,
            attr: @attr
        )
    end

end
#
# From File: views/poly_lib/client_context Order: 2
#
#require 'ostruct'
# Processed Require Line: require 'digest-rails/poly_lib/render_target'

class ClientContext
    attr_accessor :list, :references, :cursor

    def set_context_value_key( context_fullname, value_key, value )
        r = @list[context_fullname][value_key] = value

# if value_key == :render_target_absolute
#    Logger.log("---------set_context context_fullname: #{context_fullname}, value_key: #{value_key}, value: #{value}",r);
# end

        r
    end

    def get(fullname)
        @list[fullname]
    end

    def init
        @list = {}
        @references = {}

        first_cursor = RenderContext.new(
          dir: self,
          root: true,
          name: 'root',
          parent: nil
        )

        add( references[:first_cursor] = first_cursor )
    end

    def add(new_cursor)
        @cursor = @list[new_cursor.fullname]  = new_cursor
        return @cursor
    end

    def push(rt)
Logger.log('rt',rt)
        rt_fullname = rt.fullname
        existing = @list[rt_fullname]
        @cursor = if existing.nil?
Logger.log('push to NEW context',rt_fullname)
           @list[rt_fullname] = rt
        else
Logger.log('push to Existing context',rt_fullname)
           existing
        end
    end

    def pop
        @cursor = @cursor.parent
    end

    def flattened_context(cc)
        cc.ancestory.inject(RenderContext.new({})) do |context,flat|
            flat.merge! context
            flat
        end
    end

end
#
# From File: views/poly_lib/hot_helpers Order: 2
#
#################################
# HandsOnTable Compatible
#################################
#require 'axle/opal_lib/store'
# Processed Require Line: require 'digest-rails/poly_lib/column'
# Processed Require Line: require 'digest-rails/poly_lib/row'

module HotHelpers

    def map_attr_klass( digest, attr )
        if attr[-3..-1] == '_id'
           IndirectAttr.new( digest, attr )
        else
           DirectAttr.new( digest, attr )
        end
    end

    def dataSchema
    end

    def colHeaders
        r = Array(@data_source.columns).map{ |column|
            `console.log('column: ',column);`
            column.header
        }
        puts "colHeaders in HotHelpers: #{r}"
        return r
    end

    def model(opts)
    end


end
#
# From File: views/poly_lib/base_section_controller Order: 3
#
# Processed Require Line: require 'digest-rails/poly_lib/controller_context'
# Processed Require Line: require 'digest-rails/poly_lib/render'
# Processed Require Line: require 'digest-rails/opal_lib/class_template'

class BaseSectionController
    extend ClassTemplate
    include ControllerContext
    include Render

    def initialize(c)
        super
    end

end
#
# From File: views/poly_lib/pane_controller Order: 4
#
# Processed Require Line: require 'digest-rails/poly_lib/base_section_controller'
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
#
# From File: views/poly_lib/dialog_controller Order: 4
#
# Processed Require Line: require 'digest-rails/poly_lib/base_section_controller'
`console.log('class DialogController')`

class DialogController < BaseSectionController
    attr_accessor :content, :button

    class ContentController < BaseSectionController
        template Template['digest-rails/views/dialog']
    end

    class ButtonController < BaseSectionController
    end

    def self.boot
        self.new( name: :main_dialog, selector:'#myModal' ).scope do |dialog, context|
            dialog.content = ContentController.new( name: :content, context: context )
            dialog.button = ButtonController.new( name: :button, context: context, selector: 'a.custom-close-reveal-modal' )
        end
    end

    def show_text(text)
        content.render(text: text)
        link_close_button
        open
    end

    def open
        link_close_button
        Element.find(selector).foundation('reveal', 'open')
    end

    def close
        Element.find(selector).foundation('reveal', 'close')
    end

    def link_close_button
        me = self
        #Element.find(button.selector).click { me.$close() }
        `$(self.button.$selector()).click(function(){me.$close()})`
    end

end
#
# From File: views/poly_lib/runtime Order: 5
#
Element.expose :click
Element.expose :foundation

#require 'digest-rails/poly_lib/logger'
#::Logger = Logger.new

# Processed Require Line: require 'digest-rails/poly_lib/router'
::Router = Router.new( name: :router )

# Processed Require Line: require 'digest-rails/poly_lib/client_context'
::ClientContext = ClientContext.new
::ClientContext.init

#require 'axle/poly_lib/store'
#::Store = Store.new

# Processed Require Line: require 'digest-rails/poly_lib/markup_links'
::MarkupLinks = MarkupLinks.new

# Processed Require Line: require 'digest-rails/poly_lib/dialog_controller'
::Dialog = DialogController.boot(selector: '#myModal')

# Processed Require Line: require 'digest-rails/poly_lib/pane_controller'
::Pane = PaneController.boot(selector: '.content.active')
