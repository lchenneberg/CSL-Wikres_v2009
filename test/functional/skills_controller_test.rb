require 'test_helper'

class SkillsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:skills)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create skills" do
    assert_difference('Skills.count') do
      post :create, :skills => { }
    end

    assert_redirected_to skills_path(assigns(:skills))
  end

  test "should show skills" do
    get :show, :id => skills(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => skills(:one).to_param
    assert_response :success
  end

  test "should update skills" do
    put :update, :id => skills(:one).to_param, :skills => { }
    assert_redirected_to skills_path(assigns(:skills))
  end

  test "should destroy skills" do
    assert_difference('Skills.count', -1) do
      delete :destroy, :id => skills(:one).to_param
    end

    assert_redirected_to skills_path
  end
end
