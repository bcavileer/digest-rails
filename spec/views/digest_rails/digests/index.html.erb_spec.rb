require 'rails_helper'

RSpec.describe "digests/index", :type => :view do
  before(:each) do
    assign(:digests, [
      Digest.create!(
        :name => "Name"
      ),
      Digest.create!(
        :name => "Name"
      )
    ])
  end

  it "renders a list of digests" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
