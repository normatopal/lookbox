class Picture < ActiveRecord::Base
  mount_uploader :image, ImageUploader

  belongs_to :user

  validates :title, presence: true
  validates_length_of :title, :minimum => 5, :if => proc{|p| p.title.present?}
  validates :image, presence: true

end
