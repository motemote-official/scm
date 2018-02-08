class Facebook < ApplicationRecord
  has_many :fb_pics, dependent: :destroy
  accepts_nested_attributes_for :fb_pics, allow_destroy: true
end
