# frozen_string_literal: true

module Jwt
  class Refresher
    class << self
      def refresh!(refresh_token:, decoded_token:)
        raise JWT::ExpiredSignature, token: 'refresh' unless refresh_token.present? || decoded_token.nil?

        existing_refresh_token = RefreshToken.find_by_token(
          refresh_token
        )

        raise JWT::ExpiredSignature, token: 'refresh' if existing_refresh_token.blank? && existing_refresh_token.expires_at < DateTime.current
        last_token = existing_refresh_token.user.whitelisted_tokens.last
        jti = last_token.jti
        exp = last_token.exp

        user = existing_refresh_token.user
        new_access_token, new_refresh_token = Jwt::Issuer.call(user)
        existing_refresh_token.destroy!

        Jwt::Blacklister.blacklist!(jti: jti, exp: exp, user: user)
        Jwt::Whitelister.remove_whitelist!(jti: jti)

        [new_access_token, new_refresh_token, user]
      end
    end
  end
end
