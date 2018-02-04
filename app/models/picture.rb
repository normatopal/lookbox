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

  scope :category_search, -> (category_id = nil, include_subcat = nil) do
    ids = if category_id.to_i > 0
      include_subcat ? Category.find(category_id).self_and_descendants.ids : category_id
    else nil end # for uncategorized pictures
    includes(:categories).where( categories: { id: ids })
  end
  
  scope :include_subcategories, -> (include_subcat = nil) { }

  after_update :recreate_image, if: ->(obj){ !Rails.application.secrets.use_cloudinary && obj.rotation.present? }
  after_update :create_image_timetamp, if: ->(obj){ !Rails.application.secrets.use_cloudinary && obj.crop_x.present? }
  after_update :remove_previous_cloud_image, if: ->(obj){ Rails.application.secrets.use_cloudinary && obj.changes[:image].present? && !obj.remote_image_url }
  after_destroy :remove_cloud_image, if: ->(obj){ Rails.application.secrets.use_cloudinary && obj.image.url.present?}

  # whitelist the scope
  def self.ransackable_scopes(auth_object = nil)
    [:category_search, :include_subcategories]
  end

  def duplicate
    Rails.application.secrets.use_cloudinary ? self.make_cloudinary_copy : self.make_carrierwave_copy
  end

  def make_carrierwave_copy
    copy = self.dup
    copy.title += ' copy'
    CopyCarrierwaveFile::CopyFileService.new(self, copy, :image).set_file
    copy.save
    copy
  end

  def make_cloudinary_copy
    copy = Picture.new(self.attributes.except(:image).merge(id: nil, title: "#{self.title} copy"))
    copy.save
    copy.remote_image_url = self.image_url # to save image path with existing picture id
    copy.save
    copy
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
