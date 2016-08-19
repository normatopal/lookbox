require_relative '../test_helper'

class CategoryDecoratorTest < Draper::TestCase

  describe CategoryDecorator do

    let(:category) { categories(:main).decorate }

    it "returns list of possible parent categories" do
      category.available_categories_as_parent.count.must_equal 2
    end

    it "selects available picture list for category" do
      category.available_pictures.count.must_equal 2
    end

  end

end
