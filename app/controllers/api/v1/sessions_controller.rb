# frozen_string_literal: true

module Api
  module V1
    class SessionsController < ApplicationController
      def create
        user = User.find_by_email!(params[:email]).authenticate(params[:password])
        cookies.signed[:jwt] = { value: Authenticator.encode(user_payload(user)), httponly: true }

        render json: { message: 'Logged in successfully', body: { user_id: user.id } }, status: :ok
      end

      def destroy
        if current_user
          cookies.delete(:jwt)
          render json: { message: 'Logged out successfully' }, status: :ok
        else
          render json: { message: 'An error occured' }, status: :bad_request
        end
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
