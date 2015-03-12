require 'axle/opal_lib/store'
require 'digest-rails/opal_lib/markup_links'

Store = Store.new
`console.log('Opal.Store: ', Opal.Store);`

MarkupLinks = MarkupLinks.new
`console.log('Opal.MarkupLinks: ', MarkupLinks.Store);`