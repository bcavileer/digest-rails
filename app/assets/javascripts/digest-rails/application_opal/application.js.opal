require 'digest-rails/opal_lib/controller_context'

class Boot
    include ControllerContext
    attr_accessor :dialog

    class << self

        def run
            start_logger
            cc = start_client_context
            n = self.new(
               context: cc,
               name: :boot
            )

            n.render_targets
            n.markup_links
            n.boot_dialog
            n.boot_store
            n.boot_router
            n.boot_pane
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

            return ::CC
        end

        def start_dialog
        Logger.log('start_dialog')
        ::Dialog.show_text('Loading Opal App...')
        end

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

    def boot_dialog

        require 'digest-rails/opal_lib/dialog_controller'
        ::Dialog = DialogController.new( name: :main_dialog, context: self.get_context ).scope do |dialog|

            dialog[:render_target] = RenderTarget.new(selector:'#myModal')

            dialog.push(name: :content) do |content|
                content[:render_target] = RenderTarget.new(selector:'.content')
            end

            dialog.push(name: :button) do |button|
                button[:render_target] = RenderTarget.new(selector: 'a.custom-close-reveal-modal')
            end

        end
        Logger.log('Opal.Dialog', `Opal.Dialog`)
    end

    def boot_store
        require 'axle/opal_lib/store'
        ::Store = Store.new
        CC[:store] = Store
    end

    def boot_router
        require 'digest-rails/opal_lib/router'
        ::Router = Router.new( name: :router, context: self.get_context )
        Logger.log('Opal.Router', `Opal.Router`)
    end

    def boot_pane

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




