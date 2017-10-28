class Picture < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  acts_as_paranoid

  belongs_to :user
  has_many :category_pictures
  has_many :categories, -> { uniq }, :through => :category_pictures
  has_many :look_pictures, dependent: :destroy
  has_many :looks, -> { uniq }, :through => :look_pictures

  cattr_accessor(:with_subcategories) { false }
  attr_accessor :image_encoded, :rotation, :image_timestamp, :previous_id, :next_id

  validates :title, presence: true
  validates_length_of :title, :minimum => 5, :if => proc{|p| p.title.present?}
  validates :user, presence: true

  scope :uncategorized, -> { includes(:categories).where( categories: { id: nil } ) }

  # a bit odd, but of many-to-many category and picture
  scope :available_for_category, -> (cat_id) { self.all - includes(:categories).where( categories: { id: cat_id } ) }
  scope :available_for_look, -> (look_id) { self.all - includes(:looks).where( looks: { id: look_id } ) }

  scope :category_search, -> (category_id) do
    category_id = nil unless category_id.to_i > 0
    ids = Category.find(category_id).self_and_descendants.ids if self.with_subcategories && category_id
    ids ||= category_id
    includes(:categories).where( categories: { id: ids })
  end
  scope :include_subcategories, -> {}

  after_update :recreate_image, if: ->(obj){ obj.rotation.present? and obj.rotation.to_i > 0 }
  after_update :create_image_timetamp, if: ->(obj){ obj.image_changed? }

  def recreate_image
    # image.cache_stored_file!
    # image.retrieve_from_cache!(image.cache_name)
    image.recreate_versions!
    create_image_timetamp
  end

  # whitelist the scope
  def self.ransackable_scopes(auth_object = nil)
    [:category_search, :include_subcategories]
  end

  def self.switch_subcategories_flag(search_params)
    self.with_subcategories = search_params.present? && search_params['include_subcategories'] == '1'
  end

  def find_previous_next_pictures(pictures_list)
    current_index = pictures_list.index(id)
    return unless current_index
    self.previous_id = pictures_list[current_index - 1] if current_index > 0
    self.next_id = pictures_list[current_index + 1] if current_index < pictures_list.size - 1
  end

  private
  def create_image_timetamp
    self.image_timestamp = DateTime.now.to_i
  end

end
