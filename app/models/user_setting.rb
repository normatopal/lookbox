class UserSetting < ActiveRecord::Base
  belongs_to :user, :dependent => :destroy
  belongs_to :locale

end