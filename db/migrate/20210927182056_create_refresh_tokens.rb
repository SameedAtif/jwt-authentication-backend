# frozen_string_literal: true

class CreateRefreshTokens < ActiveRecord::Migration[6.1]
  def change
    create_table :refresh_tokens do |t|
      t.string :crypted_token
      t.datetime :expires_at
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :refresh_tokens, :crypted_token, unique: true
  end
end
