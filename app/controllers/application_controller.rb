# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::Cookies
  include ExceptionHandler

  before_action :authenticate

  private

  def authenticate
    current_user, decoded_token = Jwt::Authenticator.call(
      headers: cookies.encrypted[:jwt],
      access_token: params[:access_token] # authenticate from header OR params
    )

    @current_user = current_user
    @decoded_token = decoded_token
  end
end
