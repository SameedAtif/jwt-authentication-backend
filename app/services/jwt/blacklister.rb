# frozen_string_literal: true

module Jwt
  class Blacklister
    class << self

      def blacklist!(jti:, exp:, user:)
        user.blacklisted_tokens.create!(
          jti: jti,
          exp: Time.at(exp)
        )
      end

      def blacklisted?(jti:)
        BlacklistedToken.exists?(jti: jti)
      end
    end
  end
end
