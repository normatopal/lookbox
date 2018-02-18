class ApiKey < ActiveRecord::Base
  belongs_to :user_setting

  class << self
    def find_by_token(access_token)
      api_key = ApiKey.eager_load(:user_setting => :user).find_by_access_token(access_token)
      api_key if api_key && api_key.active
    end
  end

  def generate_access_token
    begin
      self.access_token = SecureRandom.urlsafe_base64(8)
    end while self.class.exists?(access_token: access_token)
    self.active = true
    set_expiration
  end

  private
  def set_expiration
    self.expires_at = DateTime.now + 30
  end

end
