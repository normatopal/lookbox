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

  it "decodes screen image" do
    encoded_str = "data:image/png;base64,qwwwqdfdfvbggghbv"
    look = looks(:first_look)
    look.screen = Picture.new(user: look.user)
    look.decode_screen_image(encoded_str)
    MIME::Types.type_for(look.screen.image.filename).first.media_type.try(:must_match, "image")
  end

  it "return if no string to encode" do
    look = looks(:first_look)
    look.screen = Picture.new(user: look.user)
    look.decode_screen_image
    look.screen.image.filename.must_be_nil
  end

end