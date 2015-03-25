Element.expose :click
Element.expose :foundation

#require 'digest-rails/poly_lib/logger'
#::Logger = Logger.new

require 'digest-rails/poly_lib/router'
::Router = Router.new( name: :router )

require 'digest-rails/poly_lib/client_context'
::ClientContext = ClientContext.new
::ClientContext.init

#require 'axle/poly_lib/store'
#::Store = Store.new

require 'digest-rails/poly_lib/markup_links'
::MarkupLinks = MarkupLinks.new

require 'digest-rails/poly_lib/dialog_controller'
::Dialog = DialogController.boot(selector: '#myModal')

require 'digest-rails/poly_lib/pane_controller'
::Pane = PaneController.boot(selector: '.content.active')

