# frozen_string_literal: true

module ExceptionHandler
  extend ActiveSupport::Concern

  class Unauthorized < StandardError
  end

  class MissingToken < StandardError
  end

  class InvalidToken < StandardError
  end

  included do
    rescue_from Unauthorized do |_e|
      render json: { message: 'You are unauthorized' }, status: :conflict
    end

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

    rescue_from MissingToken do |_e|
      render json: { message: 'Token is missing' }, status: :unprocessable_entity
    end

    rescue_from InvalidToken do |_e|
      render json: { message: 'Token is missing' }, status: :unprocessable_entity
    end
  end
end
