require 'rails_helper'

RSpec.describe "digests/show", :type => :view do
  before(:each) do
    @digest = assign(:digest, Digest.create!(
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
  end
end
