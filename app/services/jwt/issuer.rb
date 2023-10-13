# frozen_string_literal: true

module Jwt
  class Issuer
    class << self
      def call(user)
        access_token, jti, exp = Jwt::Encoder.call(user)
        refresh_token = user.refresh_tokens.create!
        Jwt::Whitelister.whitelist!(
          jti: jti,
          exp: exp,
          user: user
        )

        [access_token, refresh_token]
      end
    end
  end
end
