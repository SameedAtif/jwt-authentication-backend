# frozen_string_literal: true

module Api
  module V1
    class UsersController < BaseController
      skip_before_action :authenticate, only: %i[create]
      actions :show, :create

      private

      def permitted_params
        params.permit(:first_name, :last_name, :email, :password, :password_confirmation)
      end
    end
  end
end
