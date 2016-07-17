class CategoryPicture < ActiveRecord::Base
  belongs_to :category
  belongs_to :picture
end
