require 'test_helper'

class CShop3ControllerTest < ActionController::TestCase
  test "should get all" do
    get :all
    assert_response :success
  end

end
