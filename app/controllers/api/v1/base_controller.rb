# frozen_string_literal: true

module Api
  module V1
    class BaseController < ApplicationController
      include BaseHandler

      def index; end

      def show
        render json: resource
      end

      def create
        if new_resource.save!
          render json: new_resource, status: :ok
        else
          render json: { message: new_resource.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update; end

      def destroy; end

      protected

      def new_resource
        model.new(permitted_params)
      end

      def resource
        model.find(params[:id])
      end
    end
  end
end
