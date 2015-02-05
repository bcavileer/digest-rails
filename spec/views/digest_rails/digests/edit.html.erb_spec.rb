require 'rails_helper'

RSpec.describe "digests/edit", :type => :view do
  before(:each) do
    @digest = assign(:digest, Digest.create!(
      :name => "MyString"
    ))
  end

  it "renders the edit digest form" do
    render

    assert_select "form[action=?][method=?]", digest_path(@digest), "post" do

      assert_select "input#digest_name[name=?]", "digest[name]"
    end
  end
end
