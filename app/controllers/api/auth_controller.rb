class Api::AuthController < ApplicationController
  def register
    email = params[:email]
    password = params[:password]
    username = params[:username]

    user = User.create!(email: email, password: password, username: username)
    #
    render json: { status: 200, result: user }
  end

  def login
  end
end
