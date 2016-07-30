class Picture < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  acts_as_paranoid

  belongs_to :user
  has_many :category_pictures, inverse_of: :picture
  has_many :categories, :through => :category_pictures

  validates :title, presence: true
  validates_length_of :title, :minimum => 5, :if => proc{|p| p.title.present?}
  validates :image, presence: true

  scope :uncategorized, -> { includes(:categories).where( categories: { id: nil } ) }

  class << self
    # define scope
    def category_search(category_id)
      includes(:categories).where( categories: { id: category_id.to_i < 1 ? nil : category_id } )
    end

    # whitelist the scope
    def ransackable_scopes(auth_object = nil)
      [:category_search]
    end
  end


end
