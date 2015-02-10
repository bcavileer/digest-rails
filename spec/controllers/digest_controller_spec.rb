

  RSpec.describe DigestController, :type => :controller do

    # This should return the minimal set of attributes required to create a valid
    # Digest. As you add validations to Digest, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) {
      skip("Add a hash of attributes valid for your model")
    }

    let(:invalid_attributes) {
      skip("Add a hash of attributes invalid for your model")
    }

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # DigestsController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe "GET index" do
      it "assigns all digests as @digests" do
        digest = Digest.create! valid_attributes
        get :index, {}, valid_session
        expect(assigns(:digests)).to eq([digest])
      end
    end


  end
