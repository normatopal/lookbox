class UserLook < ActiveRecord::Base
  belongs_to :user
  belongs_to :look

  scope :shared_with_user, -> (current_user_id) { where(user_id: current_user_id) }

  validates_uniqueness_of :look_id, :scope => :user_id
end