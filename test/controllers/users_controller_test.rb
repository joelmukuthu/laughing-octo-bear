require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get add_email" do
    get :add_email
    assert_response :success
  end

end
