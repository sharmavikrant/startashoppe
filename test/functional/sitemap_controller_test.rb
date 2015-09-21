require 'test_helper'

class SitemapControllerTest < ActionController::TestCase
  test "should get site" do
    get :site
    assert_response :success
  end

end
