class Look < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :user
  has_many :look_pictures, dependent: :destroy
  has_many :pictures, -> { uniq }, :through => :look_pictures
  belongs_to :screen, :class_name => "Picture", :foreign_key => "picture_id"

  has_many :user_looks, dependent: :destroy
  has_many :shared_users, through: :user_looks, source: :user

  accepts_nested_attributes_for :look_pictures, :allow_destroy => true
  accepts_nested_attributes_for :screen
  accepts_nested_attributes_for :user_looks, :allow_destroy => true

  validates :name, presence: true
  validates_length_of :name, :minimum => 3, :if => proc{|p| p.name.present?}
  validates :user_id, presence: true

  attr_accessor :preview_image, :user_email, :shared_users_ids

  def decode_screen_image(encoded_file = nil)
    return unless encoded_file
    decoded_file = Base64.decode64(encoded_file['data:image/png;base64,'.length .. -1])
    screen_image = Tempfile.new(['image','.jpg'])
    screen_image.binmode  # set to binary mode to avoid UTF-8 conversion errors
    screen_image.write decoded_file
    self.screen.image = screen_image
  end

  private

  before_save do
    look_pictures.sort_by(&:position_order_for_sort).each_with_index do |lp, index|
      lp.position_params.merge!({top: lp.position_top, left: lp.position_left, order: index + 1})
    end
  end

end