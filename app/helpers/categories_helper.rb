module CategoriesHelper
  def categories_set
    nested_options(current_user.categories.where.not(id: [28,29])) do |i|
      "#{'-' * i.level} #{i.name}"
    end
  end
end
