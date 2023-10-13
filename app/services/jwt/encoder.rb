# frozen_string_literal: true

module Jwt
  class Encoder
    class << self
      def call(user)
        jti = SecureRandom.hex
        exp = Jwt::Encoder.token_expiry
        issued_at = Jwt::Encoder.token_issued_at
        access_token = JWT.encode(
          {
            user_id: user.id,
            jti: jti,
            iat: issued_at.to_i,
            exp: exp
          },
          Jwt::Secret.secret
        )
        user.update!(token_issued_at: issued_at)
        [access_token, jti, exp]
      end

      def token_expiry
        (Jwt::Encoder.token_issued_at + Jwt::Expiry.expiry).to_i
      end

      def token_issued_at
        DateTime.current
      end
    end
  end
end
