class User < ApplicationRecord
  has_secure_password

  has_one_attached :outfits_history
  has_one_attached :closet

  validates :email, presence: true, uniqueness: true
end
