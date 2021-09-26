# frozen_string_literal: true

class Authenticator
  class << self
    def encode(payload)
      JWT.encode validate_payload(payload), private_key, JWT_SECURITY_ALGORITHM
    end

    def decode(token, leeway = 30)
      JWT.decode token, public_key, true, { exp_leeway: leeway, algorithm: JWT_SECURITY_ALGORITHM }
    end

    private

    JWT_SECURITY_ALGORITHM = 'ED25519'
    TOKEN_VALID_DURATION = '3600'
    JWT_PRIVATE_KEY = 'abcdefghijklmnopqrstuvwxyzABCDEF'

    private_constant :JWT_SECURITY_ALGORITHM, :TOKEN_VALID_DURATION, :JWT_PRIVATE_KEY

    def validate_payload(payload)
      raise ActiveRecord::RecordInvalid unless payload[:exp]

      payload
    end

    def private_key
      # private key should be 32 in length
      RbNaCl::Signatures::Ed25519::SigningKey.new(JWT_PRIVATE_KEY)
    end

    def public_key
      private_key.verify_key
    end
  end
end
