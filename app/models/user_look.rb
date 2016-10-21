class UserLook < ActiveRecord::Base
  belongs_to :user
  belongs_to :look

  validates_uniqueness_of :look_id, :scope => :user_id
end