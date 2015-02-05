require 'rails_helper'

RSpec.describe "digests/new", :type => :view do
  before(:each) do
    assign(:digest, Digest.new(
      :name => "MyString"
    ))
  end

  it "renders new digest form" do
    render

    assert_select "form[action=?][method=?]", digests_path, "post" do

      assert_select "input#digest_name[name=?]", "digest[name]"
    end
  end
end
