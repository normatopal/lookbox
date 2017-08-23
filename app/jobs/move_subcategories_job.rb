class MoveSubcategoriesJob < ActiveJob::Base
  queue_as :default

  def perform(category_id)
    category = Category.find(category_id)
    category.move_subcategories
    #logger.info "!!!Job proceeded at #{DateTime.now}"
  end

end