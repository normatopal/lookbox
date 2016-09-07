module LooksHelper
  def get_look_picture_position(picture)
    look_picture = picture.look_pictures.select{|lp| lp.look_id.eql?(@look.id)}.first
    [look_picture.position_top, look_picture.position_left]
  end
end
