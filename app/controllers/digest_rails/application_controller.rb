require 'axle/concern/server/digests_controller_helper'

module DigestRails
  class ApplicationController < ActionController::Base
    include Axle::Concern::Server::DigestsControllerHelper
    before_filter :get_digests
  end
end
