# frozen_string_literal: true

module Jwt
  class Authenticator
    class << self
      def call(headers:)
        decoded_token = Jwt::Decoder.decode(headers)
        user = Jwt::Authenticator.authenticate_user_from_token(decoded_token)
        raise Unauthorized unless user.present?

        [user, decoded_token]
      end

      def authenticate_user_from_token(decoded_token)
        raise JWT::ExpiredSignature unless decoded_token.present? && decoded_token[:jti].present? && decoded_token[:user_id].present?

        user = User.find(decoded_token.fetch(:user_id))
        blacklisted = Jwt::Blacklister.blacklisted?(jti: decoded_token[:jti])
        whitelisted = Jwt::Whitelister.whitelisted?(jti: decoded_token[:jti])
        valid_issued_at = Jwt::Authenticator.valid_issued_at?(user, decoded_token)

        return user if !blacklisted && whitelisted && valid_issued_at
      end

      def valid_issued_at?(user, decoded_token)
        !user.token_issued_at || decoded_token[:iat] >= user.token_issued_at.to_i
      end
    end
  end
end
