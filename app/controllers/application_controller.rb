# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::Cookies
  include ExceptionHandler

  before_action :authenticate

  private

  def authenticate
    current_user, decoded_token = Jwt::Authenticator.call(
      headers: cookies.encrypted[:auth]&.split(":")&.first,
    )

    @current_user = current_user
    @decoded_token = decoded_token
  end
end
