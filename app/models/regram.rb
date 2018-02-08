class Regram < ApplicationRecord
  belongs_to :member

  belongs_to :timepool

  has_many :pics, dependent: :destroy
  accepts_nested_attributes_for :pics, allow_destroy: true
end
