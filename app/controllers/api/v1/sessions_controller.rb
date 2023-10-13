# frozen_string_literal: true

module Api
  module V1
    class SessionsController < ApplicationController
      skip_before_action :authenticate, only: %i[create update]

      def create
        user = User.find_by_email!(params[:email]).authenticate(params[:password])
        access_token, refresh_token = Jwt::Issuer.call(user)
        cookies.encrypted[:auth] = {
          value: "#{access_token}:#{refresh_token.crypted_token}",
          httponly: true,
          secure: Rails.env.production?
        }

        body = { user_id: user.id }

        render json: { message: 'Logged in successfully', body:  body }, status: :ok
      end

      def destroy
        Jwt::Revoker.revoke(decoded_token: @decoded_token, user: @current_user)
        cookies.delete(:auth)

        render json: { message: 'Logged out successfully' }, status: :ok
      end

      def update
        access_token, refresh_token, user = Jwt::Refresher.refresh!(
          refresh_token: cookies.encrypted[:auth]&.split(":")&.last, decoded_token: @decoded_token
        )

        cookies.encrypted[:auth] = {
          value: "#{access_token}:#{refresh_token.crypted_token}",
          httponly: true,
          secure: Rails.env.production?
        }

        render json: { message: 'Token refreshed', body: { user_id: user.id } }, status: :ok
      end

      private

      def permitted_params
        params.permit(:email, :password)
      end

      def user_payload(user)
        { data: { user_id: user.id }, exp: (DateTime.current + 1.hour).to_i }
      end
    end
  end
end
