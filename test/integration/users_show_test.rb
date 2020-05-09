require 'test_helper'

class UsersShowTest < ActionDispatch::IntegrationTest

  def setup
    @activated = users(:michael)
    @otheractivated = users(:archer)
    @nonactivated = users(:lana)
  end

  # users_controller_testでテストした方が良かったかも
  test "showpage as activateduser" do
    log_in_as(@activated)
    get user_path(@otheractivated)
    assert_template "users/show"
    get user_path(@nonactivated)
    assert_redirected_to root_path
  end

end
