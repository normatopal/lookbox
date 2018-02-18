class UserSetting < ActiveRecord::Base
  belongs_to :user
  belongs_to :locale
  belongs_to :look_screen_category, class_name: Category, foreign_key: "look_screen_category_id"
  has_one :api_key

  accepts_nested_attributes_for :api_key

  def active_locale
    locale || Locale.default_locale
  end

  def user_api_key
    api_key || ApiKey.new(user_setting: self)
  end

end