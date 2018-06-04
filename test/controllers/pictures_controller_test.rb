require_relative '../test_helper'

describe PicturesController do

  include SearchFilter

  before(:all) do
    @user = users(:john_doe)
  end

  it "finds pictures list by category" do
    search, pictures_list = filtered_pictures(@user.pictures, {q: {category_search: [categories(:main).id.to_s] }})
    pictures_list.count.must_equal 2
    search.class.must_equal Ransack::Search
  end

  it "finds pictures list by category with subcategories" do
    search, pictures_list = filtered_pictures(@user.pictures, {q: {category_search: [categories(:main).id.to_s], include_subcategories: '1'}})
    pictures_list.count.must_equal 3
    search.class.must_equal Ransack::Search
  end


end