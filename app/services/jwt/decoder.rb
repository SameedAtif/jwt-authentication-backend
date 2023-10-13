# frozen_string_literal: true

module Jwt
  class Decoder
    class << self

      def decode!(access_token, verify: true)
        decoded = JWT.decode(access_token, Jwt::Secret.secret, verify, verify_iat: true)[0]
        raise JWT::ExpiredSignature unless decoded.present?

        decoded.symbolize_keys
      end

      def decode(access_token, verify: true)
        decode!(access_token, verify: verify)
      rescue StandardError
        nil
      end
    end
  end
end
