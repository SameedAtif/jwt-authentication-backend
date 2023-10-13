# frozen_string_literal: true

module Jwt
  module Expiry
    module_function

    def expiry
      1.minute
    end
  end
end
