class UserSetting < ActiveRecord::Base
  belongs_to :user, :dependent => :destroy
  belongs_to :locale

  def active_locale
    locale || Locale.default_locale
  end

end