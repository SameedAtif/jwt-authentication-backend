# frozen_string_literal: true

module Api
  module V1
    class UsersController < BaseController
      actions :show, :create

      private

      # For example sake:
      # resource has been overidden only current_user will be returned after verifying the token from
      # request http_only cookie.

      # Practically:
      # We would use policy to authorize resource, authorization would include checking token through #current_user.
      def resource
        current_user
      end

      def permitted_params
        params.permit(:first_name, :last_name, :email, :password, :password_confirmation)
      end
    end
  end
end
