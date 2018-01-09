module ApplicationHelper

  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize, :f => builder)
    end
    link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")")
  end

  def active_current_page_menu(*pages)
    return 'active' if pages.any? {|page| current_page? page}
  end

  def categories_with_depth_name(categories)
    categories.collect{|cat| ["#{'-' * cat.depth} #{cat.name}", cat.id]}
  end

end
