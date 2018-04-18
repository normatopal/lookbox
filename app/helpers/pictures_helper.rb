module PicturesHelper
  def original_image_rotation(rotation)
    Rails.application.secrets.use_cloudinary && rotation ? rotation : 0
  end

  def selected_categories_for_multiselect
    categories = params.dig(:q, :category_search)
    categories = categories.flatten.delete_if{|cat| cat.blank? || cat == '0'}.join(',') if categories
    categories
  end

end
