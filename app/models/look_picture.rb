class LookPicture < ActiveRecord::Base
  belongs_to :look
  belongs_to :picture

  validates_uniqueness_of :look_id, :scope => :picture_id
end