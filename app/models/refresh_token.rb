# frozen_string_literal: true

class RefreshToken < ApplicationRecord
  belongs_to :user
  before_create :set_crypted_token

  attr_accessor :token

  def self.find_by_token(token)
    RefreshToken.find_by(crypted_token: token)
  end

  private

  def set_crypted_token
    self.token = SecureRandom.hex
    self.crypted_token = Digest::SHA256.hexdigest(token)
    self.expires_at = 1.day.from_now
  end
end
