require 'test_helper'

class BlocksControllerTest < ActionController::TestCase
  setup do
    @user  = users(:user)

    @block = blocks(:one)
  end

  test "should get index" do
    sign_in @user

    get :index
    assert_response :success
    assert_not_nil assigns(:blocks)
  end

  test "should get new" do
    sign_in @user

    get :new
    assert_response :success
  end

  test "should destroy block" do
    sign_in @user

    assert_difference('Block.count', -1) do
      delete :destroy, id: @block
    end

    assert_redirected_to blocks_path
  end
end
