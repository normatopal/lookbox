class CategoryPicture < ActiveRecord::Base
  belongs_to :category
  belongs_to :picture

  validates_uniqueness_of :category_id, :scope => :picture_id
end
