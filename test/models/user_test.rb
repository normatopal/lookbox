require_relative '../test_helper'

describe User do

  describe "change password" do

    before :each do
        @user = users(:john_doe)
    end

    it "not chages password with wrong current" do
      params = { current_password: "123455", password: "456789", password_confirmation: "456789" }
      @user.update_password_with_new(params).must_equal false
      @user.errors.count.must_equal 1
      @user.errors[:current_password].first.must_match "invalid"
    end

    it "not chages password with not correct new" do
      params = { current_password: "123456", password: "123", password_confirmation: "123" }
      @user.update_password_with_new(params).must_equal false
      @user.errors.count.must_equal 1
      @user.errors[:password].first.must_match "too short"
    end

    it "not changes password without correct confirmation" do
      params = { current_password: "123456", password: "456789", password_confirmation: "456" }
      @user.update_password_with_new(params).must_equal false
      @user.errors.count.must_equal 1
      @user.errors[:password_confirmation].first.must_match "doesn't match"
    end

    it "not changes password with any nil params" do
      params = { current_password: nil, password: nil, password_confirmation: "123" }
      @user.update_password_with_new(params).must_equal false
      @user.errors.count.must_equal 3
      @user.errors[:current_password].first.must_match "blank"
      @user.errors[:password].first.must_match "blank"
      @user.errors[:password_confirmation].first.must_match "doesn't match"
    end


    it "updates password with correct params" do
      params = { current_password: "123456", password: "456789", password_confirmation: "456789" }
      @user.update_password_with_new(params).must_equal true
    end

  end

end
