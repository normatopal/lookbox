module SearchFilter

  def filtered_pictures(pictures, params)
    SearchParams.new(params.merge({look_pictures_ids: cookies[:look_pictures_ids]})).search_pictures(pictures)
  end

  def filtered_looks(looks, params)
    SearchParams.new(params.dup).search_looks(looks)
  end

  class SearchParams

    CATEGORY_PICTURES_PER_PAGE = 6
    LOOK_PICTURES_PER_PAGE = 6

    def initialize(params = {})
      @params = params
      @params[:q] ||= {}
      prepared_picture_params
    end

    def search_pictures(user_pictures)
      search = user_pictures.search(@params[:q])
      pictures, per_page = if @params[:look_id] then available_pictures_for_look(search.result)
      elsif @params[:category_id] then available_pictures_for_category(search.result)
      else  [search.result, @kaminari_per_page] end
      [search, paginate(pictures, @params[:page], per_page)]
    end

    def search_looks(user_looks, params = @params[:q])
      search = user_looks.search(params)
      looks = paginate(wrapper(search.result, LookDecorator), @params[:page], @kaminari_per_page)
      [search, looks]
    end

    private

    def available_pictures_for_look(pictures)
      [pictures.where.not(id: @params[:look_pictures_ids].split(',')), LOOK_PICTURES_PER_PAGE]
    end

    def available_pictures_for_category(pictures)
      [pictures.available_for_category(@params[:category_id]), CATEGORY_PICTURES_PER_PAGE]
    end

    def prepared_picture_params
      #q_attributes[:category_search].try(:sub!, /\b(1)\b/,'1.0')
      params = @params[:q] #.dup
      params[:category_search] = [params[:category_search]] << params[:include_subcategories]
    end

    def paginate(objects, page, per_page)
      Kaminari.paginate_array(objects).page(page).per(per_page)
    end

    def wrapper(result, decorator)
        decorator.wrap(result)
    end

  end

end

