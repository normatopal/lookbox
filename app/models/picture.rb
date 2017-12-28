class Picture < ActiveRecord::Base
  include CopyCarrierwaveFile
  mount_uploader :image, Rails.application.secrets.use_cloudinary ? CloudinaryUploader : ImageUploader
  crop_uploaded :image
  acts_as_paranoid

  belongs_to :user
  has_many :category_pictures
  has_many :categories, -> { uniq }, :through => :category_pictures
  has_many :look_pictures, dependent: :destroy
  has_many :looks, -> { uniq }, :through => :look_pictures

  cattr_accessor(:with_subcategories) { false }
  attr_accessor :image_encoded, :image_timestamp
  serialize :transformation_params, Hash
  store_accessor :transformation_params, :rotation, :crop_x, :crop_y, :crop_w, :crop_h

  validates :title, presence: true
  validates_length_of :title, :minimum => 5, :if => proc{|p| p.title.present?}
  validates :user, presence: true

  scope :uncategorized, -> { includes(:categories).where( categories: { id: nil } ) }

  # a bit odd, but of many-to-many category and picture
  scope :available_for_category, -> (cat_id) { self.all - includes(:categories).where( categories: { id: cat_id } ) }
  #scope :available_for_look, -> (look_id) { self.all - includes(:looks).where( looks: { id: look_id } ) }

  scope :category_search, -> (category_id = nil) do
    #category_id = nil unless category_id.to_i > 0
    ids = Category.find(category_id).self_and_descendants.ids if self.with_subcategories && category_id
    ids ||= category_id
    includes(:categories).where( categories: { id: ids })
  end
  scope :include_subcategories, -> {}

  after_update :recreate_image, if: ->(obj){ !Rails.application.secrets.use_cloudinary && obj.rotation.present? }
  after_update :create_image_timetamp, if: ->(obj){ obj.crop_x.present? }
  after_destroy :remove_cloud_image, if: ->{ Rails.application.secrets.use_cloudinary }

  # whitelist the scope
  def self.ransackable_scopes(auth_object = nil)
    [:category_search, :include_subcategories]
  end

  def self.switch_subcategories_flag(search_params)
    self.with_subcategories = search_params.present? && search_params['include_subcategories'] == '1'
  end

  def duplicate_file(original)
    copy_carrierwave_file(original, self, :content_file)
    self.save!
  end

  private
  def recreate_image
    # image.cache_stored_file!
    # image.retrieve_from_cache!(image.cache_name)
    image.recreate_versions!
    create_image_timetamp
  end

  def remove_cloud_image
    Cloudinary::Uploader.destroy(self.image.public_id) if self.image.url.present?
  end

  def create_image_timetamp
    self.image_timestamp = DateTime.now.to_i
  end

end
