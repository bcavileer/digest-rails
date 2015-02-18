Rails.application.routes.draw do

  constraints(:subdomain => 'digest_rails') do
    mount DigestRails::Engine => ''
  end

end
