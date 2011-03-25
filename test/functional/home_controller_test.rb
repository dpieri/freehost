require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  test "should get subdomain" do
    get :subdomain
    assert_response :success
  end

end
