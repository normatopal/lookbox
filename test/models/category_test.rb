require_relative '../test_helper'

describe Category do

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
      categories(:main).valid?.must_equal true
    end

  end

  it "has pictures collection" do
    category = categories(:main)
    category.pictures.count.must_equal 2
  end

  it "returns categories without parent" do
    Category.main.count.must_equal 3
  end

  it "moves subcategories during parent destroy" do
    category = categories(:main)
    category.children.count.must_equal 1
    category.move_subcategories
    category.children.count.must_equal 0
  end

end