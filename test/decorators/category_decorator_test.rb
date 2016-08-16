require_relative '../test_helper'

class CategoryDecoratorTest < Draper::TestCase

  describe CategoryDecorator do

    before do
      @category = categories(:main).decorate
    end

    it "returns list of possible parent categories" do
      @category.available_categories_as_parent.count.must_equal 3
    end

    it "selects available picture list for category" do
      @category.available_pictures.count.must_equal 2
    end

  end

end
