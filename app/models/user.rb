class User < ApplicationRecord
  TEMPORARY_EMAIL_PREFIX = 'temporary@email'.freeze
  TEMPORARY_EMAIL_REGEX = /\Atemporary@email/

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter]

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :authorizations

  scope :without_user, ->(user) { where.not(id: user.id) }

  def author?(entity)
    id == entity.user_id
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email] if auth.info && auth.info[:email]
    email ||= "#{TEMPORARY_EMAIL_PREFIX}-#{auth.provider}-#{auth.uid}.com"

    user = User.where(email: email).first
    unless user
      password = Devise.friendly_token[0, 20]
      user = User.new(email: email, password: password, password_confirmation: password)
      user.skip_confirmation_notification! if user.email_temporary?
      user.save!
    end
    user.create_authorization(auth)
    user
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def email_temporary?
    email && email !~ TEMPORARY_EMAIL_REGEX
  end
end
