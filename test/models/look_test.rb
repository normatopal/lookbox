require_relative '../test_helper'

describe Look do

  describe "validation" do
    it "is not valid without name or user" do
      look = looks(:empty)
      look.valid?.must_equal false
      look.errors.count.must_equal 2
    end

    it "is not valid with too short name" do
      look = looks(:wrong)
      look.valid?.must_equal false
      look.errors.count.must_equal 1
      look.errors[:name].first.must_match "too short"
    end

  end

end