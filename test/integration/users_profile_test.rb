require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:michael)
    @otheractivateduser = users(:archer)
    @nonactivateduser = users(:tom)
  end

  # users_controller_testでテストした方が良かったかも
  test "showpage as activateduser" do
    log_in_as(@user)
    get user_path(@otheractivateduser)
    assert_template "users/show"
    get user_path(@nonactivateduser)
    assert_redirected_to root_path
  end


  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.gravatar'

    assert_select 'strong#following' # HTMLを網羅的にチェックするテストは壊れやすいから気をつける
    assert_match @user.following.count.to_s, response.body 
    assert_select 'strong#followers'
    assert_match @user.followers.count.to_s, response.body 
    
    assert_match @user.microposts.count.to_s, response.body
    assert_select 'div.pagination', count: 1
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
  end

  test "home when logged in" do
    log_in_as(@user)
    get root_path
    assert_select 'strong#following'
    assert_match @user.following.count.to_s, response.body 
    assert_select 'strong#followers'
    assert_match @user.followers.count.to_s, response.body 
  end
end
