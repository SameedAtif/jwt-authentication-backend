# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_many :refresh_tokens, dependent: :delete_all
  has_many :whitelisted_tokens, dependent: :delete_all
  has_many :blacklisted_tokens, dependent: :delete_all

  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: true
end
