class Api::ApiController < ApplicationController
  before_action :set_current_user

  skip_before_action :set_current_user, only: [ :handle_api_unauth_error, :handle_api_badreq_error, :handle_api_notfound_error ]
  rescue_from ApiUnauthError, with: :handle_api_unauth_error
  rescue_from ApiBadreqError, with: :handle_api_badreq_error
  rescue_from ApiNotfoundError, with: :handle_api_notfound_error

  def handle_api_unauth_error(exception)
    render json: { error: exception.message }, status: 401 and return
  end
  def handle_api_badreq_error(exception)
    render json: { error: exception.message }, status: 400 and return
  end
  def handle_api_notfound_error(exception)
    render json: { error: exception.message }, status: 404 and return
  end

  def current_user
    raise ApiError.new("token invalid") if @current_user.blank?
    @current_user
  end


  private

  def set_current_user
    auth_header = request.headers["Authorization"]
    raise ApiError.new("no auth header") if auth_header.blank?
    jwt = auth_header.split(" ").last rescue nil
    results = JWT.decode(jwt, Rails.application.credentials.secret_key_base, true, { algorithm: "HS256" })
    payload = results.first rescue nil
    @current_user = User.find_by_auth_token(payload["auth_token"]) rescue nil
  end
end
