require 'test_helper'

class LoginTest < Capybara::Rails::TestCase

  def setup
    @user = users(:john_doe)
  end

  test 'login user' do
    visit 'users/sign_in'
    assert page.has_content?('Email')
    assert page.has_content?('Password')
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: 'password'
    click_button 'Log in'
    assert_current_path '/'
    assert page.has_content? 'Signed in successfully'
  end

  test 'error sign up user with duplicated email and blank password' do
    visit '/users/sign_up'
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: ''
    fill_in 'Password confirmation', with: '123'
    page.find("input[name=commit]").click
    assert page.has_content? 'Email has already been taken'
    assert page.has_content? 'Password can\'t be blank'
    assert page.has_content? 'Password confirmation doesn\'t match Password'
  end

  test  'error sign up user with short password' do
    visit '/users/sign_up'
    fill_in 'Email', with: 'test@test.com'
    fill_in 'Password', with: '123'
    fill_in 'Password confirmation', with: '123'
    click_button 'Sign up'
    assert page.has_content? 'Password is too short'
  end

  test  'sign up user is successful' do
    visit '/users/sign_up'
    fill_in 'Email', with: 'test@test.com'
    fill_in 'Password', with: '123123'
    fill_in 'Password confirmation', with: '123123'
    click_button 'Sign up'
    assert_current_path root_path
    assert page.has_content? 'A message with a confirmation link'
  end

  test 'login user with google account' do
    stub_omniauth
    visit 'users/sign_in'
    assert page.has_content? 'Sign in with Google'
    click_link 'Sign in with Google'
    assert page.has_link? 'Account'
    #assert_match ActionMailer::Base.deliveries.empty?, false
  end

  private

  def stub_omniauth
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google] = OmniAuth::AuthHash.new({
                                                                  provider: 'google',
                                                                  uid: rand(1000..10000),
                                                                  info: {
                                                                          name: @user.name,
                                                                          email: @user.email
                                                                  }
                                                                })
  end

end