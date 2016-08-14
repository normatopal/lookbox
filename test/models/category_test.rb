require_relative '../test_helper'

describe Category do

  describe "validation" do
    it "not not valid with too short name" do
      category = categories(:oh)
      category.valid?.must_equal false
      category.errors.count.must_equal 1
      category.errors[:name].first.must_match "too short"
    end
  end

  it "has pictures collection" do
    category = categories(:main)
    category.pictures.count.must_equal 2
  end

end