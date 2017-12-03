module SearchFilter

  CATEGORY_PICTURES_PER_PAGE = 5
  LOOK_PICTURES_PER_PAGE = 5
  ITEMS_PER_PAGE = @kaminari_per_page

  def filtered_pictures(pictures, params)
    search_params = params[:q].try(:clone)
    Picture.switch_subcategories_flag(search_params)
    search_params.try('category_search').try(:sub!, /\b(1)\b/,'1.0')
    search = pictures.search(search_params)
    pictures = paginate(*available_pictures(search, params))
    search_params.try('category_search').try(:sub!, /\b(1.0)\b/,'1')
    [search, pictures]
  end

  def filtered_looks(looks, params)
    search = looks.search(params[:q])
    looks = paginate(wrapper(search.result, LookDecorator), params[:page], ITEMS_PER_PAGE)
    [search, looks]
  end

  private

  def available_pictures(search, params)
    pictures, per_page = if params[:look_id]
        [search.result.where.not(id: cookies[:look_pictures_ids].split(',')), LOOK_PICTURES_PER_PAGE]
      elsif params[:category_id]
        [search.result.available_for_category(params[:category_id]), CATEGORY_PICTURES_PER_PAGE]
      else
        [search.result, ITEMS_PER_PAGE]
    end
    #[wrapper(pictures, PictureDecorator), params[:page], per_page]
    [pictures, params[:page], per_page]
  end


  def wrapper(result, decorator)
      decorator.wrap(result)
  end

  def paginate(objects, page, per_page)
    Kaminari.paginate_array(objects).page(page).per(per_page)
  end

end