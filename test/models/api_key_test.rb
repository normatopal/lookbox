require_relative '../test_helper'

describe ApiKey do

  before :each do
    @api_key = api_keys(:john_doe_api_key)
  end

  it "it generates new access token" do
    @api_key.generate_access_token
    ApiKey.exists?(access_token: @api_key.access_token).must_equal false
    @api_key.expires_at.wont_be_nil nil
  end

  it "has expiration date after token generation" do
    @api_key.generate_access_token
    @api_key.expires_at.wont_be_nil nil
  end

  it "set active api key" do
    @api_key.save
    @api_key.active.must_equal true
  end

end
