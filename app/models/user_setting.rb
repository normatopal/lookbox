class UserSetting < ActiveRecord::Base
  belongs_to :user, :dependent => :destroy
  belongs_to :locale
  belongs_to :look_screen_category, class_name: Category, foreign_key: "look_screen_category_id"

  def active_locale
    locale || Locale.default_locale
  end

end