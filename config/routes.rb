DigestRails::Engine.routes.draw do
  get '/digests_crosses_json', to: 'digest#digests_crosses_json', as: 'digests_crosses_json'
end
