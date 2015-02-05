require "rails_helper"

module DigestRails
  RSpec.describe DigestsController, :type => :routing do
    describe "routing" do
  
      it "routes to #index" do
        expect(:get => "/digests").to route_to("digests#index")
      end
  
      it "routes to #new" do
        expect(:get => "/digests/new").to route_to("digests#new")
      end
  
      it "routes to #show" do
        expect(:get => "/digests/1").to route_to("digests#show", :id => "1")
      end
  
      it "routes to #edit" do
        expect(:get => "/digests/1/edit").to route_to("digests#edit", :id => "1")
      end
  
      it "routes to #create" do
        expect(:post => "/digests").to route_to("digests#create")
      end
  
      it "routes to #update" do
        expect(:put => "/digests/1").to route_to("digests#update", :id => "1")
      end
  
      it "routes to #destroy" do
        expect(:delete => "/digests/1").to route_to("digests#destroy", :id => "1")
      end
  
    end
  end
end
