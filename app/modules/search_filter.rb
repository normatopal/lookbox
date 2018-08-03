module SearchFilter

  def filtered_pictures(pictures, params)
    params[:q][:category_search] = [params[:q][:category_search]].prepend(params[:q][:include_subcategories]) if params[:q]
    SearchParams.new(params.merge({look_pictures_ids: cookies[:look_pictures_ids]})).search_pictures(pictures)
  end

  def filtered_looks(looks, params)
    SearchParams.new(params.dup).search_looks(looks)
  end

  class SearchParams

    CATEGORY_PICTURES_PER_PAGE = 6
    LOOK_PICTURES_PER_PAGE = 6
    DEFAULT_SEARCH_ORDER = 'updated_at desc'

    def initialize(params = {})
      @params = params
      @params[:q] ||= {}
      #prepared_picture_params
    end

    def search_pictures(user_pictures)
      search = user_pictures.search(@params[:q])
      search.sorts = 'updated_at desc' if search.sorts.empty?
      pictures, per_page = if @params[:look_id] then
        available_pictures_for_look(search.result)
      elsif @params[:category_id] then available_pictures_for_category(search.result)
      else  [search.result, @kaminari_per_page] end
      [search, paginate(pictures, @params[:page], per_page)]
    end

    def search_looks(user_looks, params = @params[:q])
      search = user_looks.search(params)
      search.sorts = DEFAULT_SEARCH_ORDER if search.sorts.empty?
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
      params = @params[:q] #.dup
      params[:category_search] = [params[:category_search]].prepend(params[:include_subcategories])
    end

    def paginate(objects, page, per_page)
      Kaminari.paginate_array(objects).page(page).per(per_page)
    end

    def wrapper(result, decorator)
        decorator.wrap(result)
    end

  end

end

