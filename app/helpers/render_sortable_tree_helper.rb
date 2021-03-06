# DOC:
# We use Helper Methods for tree building,
# because it's faster than View Templates and Partials

# SECURITY note
# Prepare your data on server side for rendering
# or use h.html_escape(node.content)
# for escape potentially dangerous content
module RenderSortableTreeHelper
  module Render 
    class << self
      attr_accessor :h, :options

      def render_node(h, options)
        @h, @options = h, options
        node = options[:node]
        expand_element = "<span class='category-expand glyphicon glyphicon-minus'></span>" if children

        "
          <li data-node-id='#{ node.id }'>
            <div class='item'>
              <i class='handle'></i>
              #{expand_element || ''}
              #{ show_link }
              #{ controls }
            </div>
            #{ children }
          </li>
        "
      end

      def show_link
        node = options[:node]
        ns   = options[:namespace]
        url = h.url_for(:controller => options[:klass].pluralize, :action => :show, :id => node)
        title_field = options[:title]

        "<h4>#{ h.link_to(node.send(title_field), url, remote: true) }</h4>"
      end

      def controls
        node = options[:node]

        new_path = h.url_for(:controller => options[:klass].pluralize, :action => :new, :parent_id => node)
        edit_path = h.url_for(:controller => options[:klass].pluralize, :action => :edit, :id => node)
        destroy_path = h.url_for(:controller => options[:klass].pluralize, :action => :destroy, :id => node)
        available_pictures_path = h.url_for(:controller => 'pictures', :action => :index, :category_id => node)
        pictures_count_id = "category_#{node.id}_pictures_count"

        "
          <div class='controls'>
            <div class='category-pictures-count' id=#{pictures_count_id} title='Pictures count'>#{node.pictures.length}</div>
            #{ h.link_to '', available_pictures_path, :title => "Add pictures", :class => "category-add-image-icon", :remote => :true }
            #{ h.link_to '', new_path, :title => "Add subcategory", :class => :new, :remote => :true }
            #{ h.link_to '', edit_path, :class => :edit, :remote => :true }
            #{ h.link_to '', destroy_path, :class => :delete, :method => :delete, :data => { :confirm => 'Are you sure?' } }
          </div>
        "
      end

      def children
        unless options[:children].blank?
          "<ol class='nested_set'>#{ options[:children] }</ol>"
        end
      end

    end
  end
end
