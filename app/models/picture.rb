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
    #includes(:categories).where( categories: { id: category_id })
    ids = Category.find(category_id).self_and_descendants.ids if self.with_subcategories && category_id
    ids ||= category_id
    includes(:categories).where( categories: { id: ids })
  end
  

  scope :include_subcategories, -> {}
#  ->(category_id) do
#    ids = Category.find(category_id).self_and_descendants.ids if category_id
#    includes(:categories).where( categories: { id: ids ||= []})
#  end

  after_update :recreate_image, if: ->(obj){ !Rails.application.secrets.use_cloudinary && obj.rotation.present? }
  after_update :create_image_timetamp, if: ->(obj){ !Rails.application.secrets.use_cloudinary && obj.crop_x.present? }
  after_update :remove_previous_cloud_image, if: ->(obj){ Rails.application.secrets.use_cloudinary && obj.changes[:image].present? && !obj.remote_image_url }
  after_destroy :remove_cloud_image, if: ->(obj){ Rails.application.secrets.use_cloudinary && obj.image.url.present?}

  # whitelist the scope
  def self.ransackable_scopes(auth_object = nil)
    [:category_search, :include_subcategories]
  end

  def self.switch_subcategories_flag(search_params)
    self.with_subcategories = search_params.present? && search_params['include_subcategories'] == '1'
  end

  def duplicate
    Rails.application.secrets.use_cloudinary ? self.make_cloudinary_copy : self.make_carrierwave_copy
  end

  def make_carrierwave_copy
    new_picture = self.dup
    new_picture.title += ' copy'
    CopyCarrierwaveFile::CopyFileService.new(self, new_picture, :image).set_file
    new_picture.save
    new_picture
  end

  def make_cloudinary_copy
    new_picture = Picture.new(self.attributes.except(:image).merge(id: nil, title: "#{self.title} copy"))
    new_picture.save
    new_picture.remote_image_url = self.image_url
    new_picture.save
    new_picture
  end

  private
  def recreate_image
    image.recreate_versions!
    create_image_timetamp
  end

  def remove_cloud_image(public_id = self.image.public_id)
    Cloudinary::Uploader.destroy(public_id)
  end

  def remove_previous_cloud_image
    previous_image = self.changes.fetch(:image).first
    previous_public_id = CloudinaryUploader::CLOUD_FOLDER + previous_image.url.split(CloudinaryUploader::CLOUD_FOLDER).last.split('.').first
    remove_cloud_image(previous_public_id)
  end

  def create_image_timetamp
    self.image_timestamp = DateTime.now.to_i
  end

end
