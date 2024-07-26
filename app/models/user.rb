class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_many :posts

  before_create :generate_auth_token

  def generate_auth_token
    self.auth_token = SecureRandom.uuid
  end

  def jwt(exp = 15.days.from_now)
    JWT.encode({
      exp: exp.to_i,
      auth_token: self.auth_token
    }, Rails.application.credentials.secret_key_base, "HS256")
  end

  def as_jwt
    json = {}
    json[:username] = self.username
    json[:jwt] = self.jwt
    json
  end
end
