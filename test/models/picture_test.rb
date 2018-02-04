require_relative '../test_helper'

describe Picture do

  describe "validation" do
    it "is not valid without title or user" do
      picture = pictures(:empty)
      picture.valid?.must_equal false
      picture.errors.count.must_equal 2
    end

    it "is not valid with too short title" do
      picture = pictures(:wrong)
      picture.valid?.must_equal false
      picture.errors.count.must_equal 1
      picture.errors[:title].first.must_match "too short"
    end

    it "is valid with correct attributes" do
      pictures(:right).valid?.must_equal true
    end
  end

  it "has categories collection" do
    picture = pictures(:my_selfie)
    picture.categories.count.must_equal 1
  end

  it "select uncategorized pictures" do
    Picture.uncategorized.count.must_equal 3
  end

end
