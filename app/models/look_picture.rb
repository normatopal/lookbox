class LookPicture < ActiveRecord::Base
  belongs_to :look
  belongs_to :picture

  validates_uniqueness_of :look_id, :scope => :picture_id

  attr_accessor :preview_image, :position_top, :position_left, :position_order
  serialize :position_params, Hash

  def order_number
    position_params[:order] || 1
  end

  def position_order_for_sort
    position_order.to_i
  end

end