# frozen_string_literal: true

module Jwt
  class Revoker
    class << self
      def revoke(decoded_token:, user:)
        jti = decoded_token.fetch(:jti)
        exp = decoded_token.fetch(:exp)

        Jwt::Whitelister.remove_whitelist!(jti: jti)
        Jwt::Blacklister.blacklist!(
          jti: jti,
          exp: exp,
          user: user
        )
      rescue StandardError
        raise JWT::ExpiredSignature
      end
    end
  end
end
