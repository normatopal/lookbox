class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  acts_as_paranoid

  has_many :pictures
  has_many :categories
  has_many :looks

  validates :email, presence: true

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

    #clean_up_passwords
    result
  end

end
