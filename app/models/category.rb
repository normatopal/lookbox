class Category < ActiveRecord::Base

  belongs_to :user
  #has_many :pictures
  has_many :category_pictures
  has_many :pictures, :through => :category_pictures

  attr_accessor :name_with_depth, :delete_with_sub
  acts_as_nested_set

  # has_many :subcategories, :class_name => "Category", :foreign_key => "parent_id", :dependent => :destroy
  # belongs_to :parent, :class_name => "Category"

  scope :main, -> { where(parent: nil)}
  #default_scope { order('depth, name') }
  scope :name_order, -> { reorder('name DESC') }
  scope :created_order, -> { reorder('created_at, name') }

  before_save do |cat|
   cat.user = cat.parent.user if cat.parent.present?
  end

  def name_with_depth
   '-' * depth + " " + name.to_s
  end

end