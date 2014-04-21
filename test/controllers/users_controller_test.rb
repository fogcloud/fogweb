require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @admin = users(:admin)
    @user  = users(:user)
  end

  test "should get index" do
    sign_in @admin

    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

# Create process replaced by devise.
#
#  test "should get new" do
#    get :new
#    assert_response :success
#  end
#
#  test "should create user" do
#    assert_difference('User.count') do
#      post :create, user: { email: "frank@example.com" }
#    end
#
#    assert_redirected_to user_path(assigns(:user))
#  end

  test "should show user" do
    sign_in @admin

    get :show, id: @user
    assert_response :success
  end

  test "should get edit" do
    sign_in @admin
    
    get :edit, id: @user
    assert_response :success
  end

  test "should update user" do
    sign_in @admin

    patch :update, id: @user, user: { email: "frank@example.com" }
    assert_redirected_to user_path(assigns(:user))
  end

  test "should destroy user" do
    sign_in @admin

    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end

    assert_redirected_to users_path
  end
end
