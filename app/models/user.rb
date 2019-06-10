class User < ApplicationRecord
  devise :database_authenticatable, :token_authenticatable

  before_save :add_auth_token, on: :create


  def add_auth_token
    if self.authentication_token.nil?
      self.authentication_token = SecureRandom.base58(25)
      self.authentication_token_created_at = Time.current
    end
  end


end
