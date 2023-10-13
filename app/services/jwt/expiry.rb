# frozen_string_literal: true

module Jwt
  class Expiry
    class << self
      def expiry
        1.minute
      end
    end
  end
end
