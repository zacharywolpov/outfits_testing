class User < ApplicationRecord
  has_one_attached :outfits_history
  has_one_attached :closet
end
