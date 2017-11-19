class UserLook < ActiveRecord::Base
  belongs_to :user
  belongs_to :look

  scope :shared_with_user, -> (current_user_id) { where(user_id: current_user_id) }
  scope :find_user_look, -> (u_id, l_id) { where(user_id: u_id, look_id: l_id).first }

  validates_uniqueness_of :look_id, :scope => :user_id
end