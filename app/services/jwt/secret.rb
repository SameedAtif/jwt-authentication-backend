# frozen_string_literal: true

module Jwt
  class Secret
    class << self
      def secret
        Rails.application.secrets.secret_key_base
      end
    end
  end
end
