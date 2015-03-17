class Boot
    class << self
        def run
            n = self.new
            n.start_logger
            n.start_client_context
            n.render_targets
            n.markup_links
            n.dialog
            n.store
            n.pane
        end

        def start_dialog
            CC.push(name: :dialog) do |fCC|
                Logger.log("fCC dialog2",fCC)
                fCC[:content] = 'hello'
                fCC[:controller].open

            end
        end

    end

    def start_logger
        require 'digest-rails/opal_lib/logger'
        ::Logger = Logger.new
    end

    def start_client_context
        require 'digest-rails/opal_lib/client_context'
        ::CC = ClientContext.new.init

        Logger.log('Opal.Logger', `Opal.Logger`)
        CC[:logger] = Logger
    end



    def render_targets
        require 'digest-rails/opal_lib/render_target'
        RenderTargetFactory = RenderTarget
        CC[:render_target_factory] = RenderTargetFactory
    end

    def markup_links
        require 'digest-rails/opal_lib/markup_links'
        ::MarkupLinks = MarkupLinks.new
        CC[:markup_links] = MarkupLinks
    end

    def dialog
        require 'digest-rails/opal_lib/dialog'
        CC.push(name: :dialog) do |fCC|

            fCC[:render_target] = RenderTarget.new(selector:'#myModal')
            fCC[:controller] = Dialog.new(cc_dir: fCC.dir, render_context: fCC)

            fCC.push(name: :content) do |fCC|
                fCC[:render_target] = RenderTarget.new(selector:'.content')
            end

            fCC.push(name: :button) do |fCC|
                fCC[:render_target] = RenderTarget.new(selector: 'a.custom-close-reveal-modal')
            end

        end
    end

    def store
        require 'axle/opal_lib/store'
        Store = Store.new
        CC[:store] = Store
    end

    def pane

        CC.push(name: :Pane) do |fCC|

            Logger.log('ClientContext: ', `Opal.CC`)

            fCC[:render_target] = RenderTarget.new( selector:'.content.active' )

            fCC.push(name: :header) do |fCC|
                fCC[:render_target] = RenderTarget.new(selector:'.header')
            end

            fCC.push(name: :pane) do |fCC|
                fCC[:render_target] = RenderTarget.new(selector:'.pane')
            end

            fCC.push(name: :footer) do |fCC|
                fCC[:render_target] = RenderTarget.new(selector:'.footer')
            end

        end
    end
end

Boot.run




