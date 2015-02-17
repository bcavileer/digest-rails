DigestRails::Engine.routes.draw do
  get '/digests', to: 'digests#index', as: 'digests'
  get '/digests/name_server/:engine/:route_name', to: 'digests#name_server', as: 'digests_name_server'

  get '/digest/:id', to: 'digest#show', as: 'digest'
end
