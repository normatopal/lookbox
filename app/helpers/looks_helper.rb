module LooksHelper
  def get_look_picture_position(picture)
    look_picture = picture.look_pictures.select{|lp| lp.look_id.eql?(@look.id)}.first
    result = [0, 0]
    result = [look_picture.position_top, look_picture.position_left] if look_picture.present?
    result
  end
end
