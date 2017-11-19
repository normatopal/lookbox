module PicturesHelper

  def detect_next_previous_ids(pictures, index)
    picture = pictures[index]
    picture.previous_id = pictures[index - 1].id if index > 0
    picture.next_id = pictures[index + 1].id if index < pictures.size - 1
    picture
  end

end
