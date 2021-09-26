# frozen_string_literal: true

class ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordInvalid do |_e|
      render json: { message: 'Record is invalid' }, status: :unprocessable_entity
    end

    rescue_from ActiveRecord::RecordNotFound do |_e|
      render json: { message: 'Record not found.' }, status: :not_found
    end

    rescue_from ActiveRecord::RecordNotUnique do |_e|
      render json: { message: 'Record already exists.' }, status: :unprocessable_entity
    end

    rescue_from JWT::ExpiredSignature do |_e|
      render json: { message: 'Session has expired' }, status: :conflict
    end

    rescue_from JWT::DecodeError do |_e|
      render json: { message: 'Invalid session' }, status: :conflict
    end
  end
end
