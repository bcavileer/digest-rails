require 'digest-rails/opal_lib/logger'
require 'digest-rails/opal_lib/render_target'
require 'digest-rails/opal_lib/render_targets'

require 'axle/opal_lib/store'
require 'digest-rails/opal_lib/markup_links'
require 'digest-rails/opal_lib/dialog'

Logger = Logger.new
Logger.log('Opal.Logger', `Opal.Logger`)

RenderTargetFactory = RenderTarget
Logger.log('Opal.RenderTarget:', `Opal.RenderTargetFactory`)

ActivePaneRenderTargets = RenderTargets.new(
    parent: RenderTarget.new( '.content.active' ),
    children: {
        header: RenderTarget.new( '.header' ),
        body: RenderTarget.new( '.pane' ),
        footer: RenderTarget.new( '.footer' )
    }
)

Store = Store.new
Logger.log('Opal.Store: ', `Opal.Store`)

MarkupLinks = MarkupLinks.new
Logger.log('Opal.MarkupLinks: ', `Opal.MarkupLinks`)

Dialog = Dialog.new(
    parent: RenderTarget.new( '#myModal' ),
    children: {
        content: RenderTarget.new( '.content' ),
        button:  RenderTarget.new( 'a.custom-close-reveal-modal' )
    }
)

Logger.log('Opal.Dialog: ', `Opal.Dialog`)
