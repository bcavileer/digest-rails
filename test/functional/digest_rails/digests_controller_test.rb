require 'test_helper'

module DigestRails
  class DigestsControllerTest < ActionController::TestCase
    setup do
      @digest = digests(:one)
    end
  
    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:digests)
    end
  
    test "should get new" do
      get :new
      assert_response :success
    end
  
    test "should create digest" do
      assert_difference('Digest.count') do
        post :create, digest: { name: @digest.name }
      end
  
      assert_redirected_to digest_path(assigns(:digest))
    end
  
    test "should show digest" do
      get :show, id: @digest
      assert_response :success
    end
  
    test "should get edit" do
      get :edit, id: @digest
      assert_response :success
    end
  
    test "should update digest" do
      put :update, id: @digest, digest: { name: @digest.name }
      assert_redirected_to digest_path(assigns(:digest))
    end
  
    test "should destroy digest" do
      assert_difference('Digest.count', -1) do
        delete :destroy, id: @digest
      end
  
      assert_redirected_to digests_path
    end
  end
end
