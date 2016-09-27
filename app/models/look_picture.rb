class LookPicture < ActiveRecord::Base
  belongs_to :look
  belongs_to :picture

  validates_uniqueness_of :look_id, :scope => :picture_id

  attr_accessor :preview_image, :position_top, :position_left
  serialize :position_params, Hash

end