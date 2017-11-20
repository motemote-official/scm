class RocketRegram < ApplicationRecord
  has_many :rocket_pics, dependent: :destroy
  accepts_nested_attributes_for :rocket_pics, allow_destroy: true

  belongs_to :rocket
end
