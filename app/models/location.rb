class Location < ApplicationRecord
  validates :location, presence: true
  validates :user_id, presence: true, uniqueness: true
end
