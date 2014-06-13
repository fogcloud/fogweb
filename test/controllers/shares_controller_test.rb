require 'test_helper'

require 'digest/sha2'

class SharesControllerTest < ActionController::TestCase
  setup do
    @share = shares(:one)
    @user  = users(:user)
    @name  = Digest::SHA256.hexdigest("new name")
  end

  test "should not create with bad auth key" do
    assert_difference('Share.count', 0) do
      post :create, format: 'json', auth: "derp", share: { name: @share.name, root: @share.root }
    end

    assert_response :unauthorized
  end

  test "should create share" do
    assert_difference('Share.count') do
      post :create, format: 'json', auth: @user.auth_key, share: { name: @name, root: "" }
    end

    assert_response :success
  end

  test "should update share" do
    patch :update, format: 'json', auth: @user.auth_key, name: @share.name, 
      share: { name: @name, root: @share.root }
    assert_response :success
  end

  test "should destroy share" do
    assert_difference('Share.count', -1) do
      delete :destroy, format: 'json', auth: @user.auth_key, name: @share.name
    end

    assert_response :success
  end
end
