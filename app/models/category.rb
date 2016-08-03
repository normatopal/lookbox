class Category < ActiveRecord::Base
  include TheSortableTree::Scopes
  acts_as_nested_set

  belongs_to :user
  has_many :category_pictures
  has_many :pictures, :through => :category_pictures

  attr_accessor :name_with_depth
  accepts_nested_attributes_for :category_pictures
  accepts_nested_attributes_for :pictures

  # has_many :subcategories, :class_name => "Category", :foreign_key => "parent_id", :dependent => :destroy
  # belongs_to :parent, :class_name => "Category"

  scope :main, -> { where(parent: nil)}
  #default_scope { order('depth, name') }
  scope :name_order, -> { reorder('name DESC') }
  scope :created_order, -> { reorder('created_at, name') }

  before_save do |cat|
   cat.user = cat.parent.user if cat.parent.present?
  end

  def move_subcategories
    self.children.each do |cat_child|
      if cat_child.depth > 1
        cat_child.move_to_child_of(cat_child.parent.parent)
      else
        cat_child.move_to_root
      end
    end
    self.reload
  end


  def name_with_depth
   '-' * depth + ' ' + name.to_s
  end

  def title
    name
  end

end