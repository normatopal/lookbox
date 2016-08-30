require_relative '../test_helper'

describe Category do

  let(:main_category) { categories(:main) }

  describe "validation" do

    it "not not valid with too short name" do
      category = categories(:oh)
      category.valid?.must_equal false
      category.errors.count.must_equal 1
      category.errors[:name].first.must_match "too short"
    end

    it "is not valid without name or user" do
      category = categories(:wrong)
      category.valid?.must_equal false
      category.errors.count.must_equal 2
    end

    it "is valid with correct attributes" do
      main_category.valid?.must_equal true
    end

  end

  describe "check class and instance methods" do

    it "has pictures collection" do
      main_category.pictures.count.must_equal 2
    end

    it "returns categories without parent" do
      Category.main.count.must_equal 3
    end

    it "moves subcategories during parent destroy" do
      main_category.children.count.must_equal 1
      main_category.move_subcategories
      main_category.children.count.must_equal 0
    end

  end

end