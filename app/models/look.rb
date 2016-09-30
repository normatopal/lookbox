class Look < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :user
  has_many :look_pictures, dependent: :destroy
  has_many :pictures, -> { uniq }, :through => :look_pictures
  belongs_to :screen, :class_name => "Picture", :foreign_key => "picture_id"

  accepts_nested_attributes_for :look_pictures
  accepts_nested_attributes_for :screen

  validates :name, presence: true
  validates_length_of :name, :minimum => 3, :if => proc{|p| p.name.present?}
  validates :user_id, presence: true

  attr_accessor :preview_image

  def get_image_from_str(encoded_file)
    decoded_file = Base64.decode64(encoded_file['data:image/png;base64,'.length .. -1])
    screen_image = Tempfile.new(['image','.jpg'])
    screen_image.binmode  # set to binary mode to avoid UTF-8 conversion errors
    screen_image.write decoded_file
    screen_image
  end

  private

  before_save do
    look_pictures.each do |lp|
      lp.position_params.megre!({left: lp.position_top}) if lp.position_top.present?
      lp.position_params.megre!({left: lp.position_left}) if lp.position_left.present?
      lp.position_params.megre!({left: lp.position_zindex}) if lp.position_zindex.present?
    end
  end

end