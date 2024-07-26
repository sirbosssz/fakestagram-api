class Api::AuthController < Api::ApiController
  skip_before_action :set_current_user, only: [ :register, :login ]

  def register
    email = params[:email]
    password = params[:password]
    username = params[:username]

    exists_user = User.find_by_email(email)
    raise ApiBadreqError.new("email already exists") if !exists_user.blank?

    user = User.create!(email: email, password: password, username: username)
    #
    render json: { result: user }
  end

  def login
    email = params[:email]
    password = params[:password]

    user = User.find_by_email(email)

    raise ApiBadreqError.new("user not found") if user.blank?

    if user.valid_password?(password)
      render json: { result: user.as_jwt }
    else
      raise ApiBadreqError.new("invalid password")
    end
  end

  def logout
    user = current_user
    user.generate_auth_token
    user.save
    render json: { message: "logged out" }
  end

  def check
    if current_user
      render json: { message: "token valid" }
    end
  end
end
