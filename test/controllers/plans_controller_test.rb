require 'test_helper'

class PlansControllerTest < ActionController::TestCase
  setup do
    @admin = users(:admin)

    @plan  = plans(:default)
  end

  test "should get index" do
    sign_in @admin

    get :index
    assert_response :success
    assert_not_nil assigns(:plans)
  end

  test "should get new" do
    sign_in @admin

    get :new
    assert_response :success
  end

  test "should create plan" do
    sign_in @admin

    assert_difference('Plan.count') do
      post :create, plan: { megs: @plan.megs, name: @plan.name, price_usd: @plan.price_usd }
    end

    assert_redirected_to plan_path(assigns(:plan))
  end

  test "should show plan" do
    sign_in @admin

    get :show, id: @plan
    assert_response :success
  end

  test "should get edit" do
    sign_in @admin

    get :edit, id: @plan
    assert_response :success
  end

  test "should update plan" do
    sign_in @admin

    patch :update, id: @plan, plan: { megs: @plan.megs, name: @plan.name, price_usd: @plan.price_usd }
    assert_redirected_to plan_path(assigns(:plan))
  end

  test "should destroy plan" do
    sign_in @admin

    assert_difference('Plan.count', -1) do
      delete :destroy, id: plans(:plan2)
    end

    assert_redirected_to plans_path
  end
end
