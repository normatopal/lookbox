class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable,
         :omniauth_providers => [:google]

  acts_as_paranoid

  has_many :pictures
  has_many :categories
  has_many :looks

  has_many :user_looks, dependent: :destroy
  has_many :shared_looks, through: :user_looks, source: :look
  has_one :user_setting

  validates :name, uniqueness: true, if: 'name.present?'

  attr_readonly :email

  def update_password_with_new(params)
    current_password = params.delete(:current_password)

    result =
      if valid_password?(current_password)
        update_attributes(params)
      else
        self.assign_attributes(params)
        self.valid?
        self.errors.add(:current_password, current_password.blank? ? :blank : :invalid)
        false
      end
    result
  end

  def self.from_omniauth(auth)
    user = self.find_by_email(auth.info.email)
    if user
      user.uid, user.provider = auth.uid, auth.provider
      user.save if user.changed?
    else
      user_password = SecureRandom.urlsafe_base64(6)
      user = self.create do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.email = auth.info.email
        user.name = auth.info.name
        user.password = user_password
        user.skip_confirmation!
      end
      UserMailer.google_user_site_password(user, user_password).deliver_later if user.persisted?
    end
    user
  end

end
