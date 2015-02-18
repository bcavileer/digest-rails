DigestRails::Engine.routes.draw do
  get '/name_server/:engine/:route_name', to: 'digests#name_server', as: 'digests_name_server'
  get '/digest/:digest_index', to: 'digest#show', as: 'digest'
end
