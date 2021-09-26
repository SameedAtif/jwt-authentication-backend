# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::Cookies
  include ExceptionHandler

  protected

  def current_user
    token = Authenticator.decode(cookies.signed[:jwt])[0].symbolize_keys
    User.find(token.dig(:data, :user_id))
  end
end
