class User < ApplicationRecord
  has_secure_password
  has_many :video_shares
  validates :username, presence: true, uniqueness: true
end
