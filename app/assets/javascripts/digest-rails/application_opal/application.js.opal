require 'axle/opal_lib/store'
require 'digest-rails/opal_lib/markup_links'
require 'digest-rails/opal_lib/dialog'

Store = Store.new
`console.log('Opal.Store: ', Opal.Store);`

MarkupLinks = MarkupLinks.new
`console.log('Opal.MarkupLinks: ', Opal.MarkupLinks);`

Dialog = Dialog.new
`console.log('Opal.Dialog: ', Opal.Dialog);`