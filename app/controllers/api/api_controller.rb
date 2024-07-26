class Api::ApiController < ApplicationController
  before_action :set_current_user

  def current_user
    raise Exception.new("token invalid") if @current_user.blank?
    @current_user
  end


  private

  def set_current_user
    auth_header = request.headers["Authorization"]
    raise Exception.new("no auth header") if auth_header.blank?
    jwt = auth_header.split(" ").last rescue nil
    results = JWT.decode(jwt, Rails.application.credentials.secret_key_base, true, { algorithm: "HS256" })
    payload = results.first rescue nil
    @current_user = User.find_by_auth_token(payload["auth_token"]) rescue nil
  end
end
